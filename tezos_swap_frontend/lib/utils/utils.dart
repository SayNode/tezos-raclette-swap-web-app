import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/chart_datapoint.dart';
import '../models/token.dart';
import '../services/contract_service.dart';
import '../services/token_service.dart';

double roundDouble(double value, int places) {
  double mod = pow(10.0, places) as double;
  return ((value * mod).round().toDouble() / mod);
}

//TODO: find better way
BigInt etherToWei(num amount, int decimals) {
  String amountString = amount.toString();
  if (!amountString.contains('.')) {
    amountString = amountString + '.0';
  }
  var list = amountString.split('.');
  var nachKomma = list[1];
  while (nachKomma.length < 18) {
    nachKomma = nachKomma + '0';
  }
  return BigInt.parse(list[0] + nachKomma);
}

Future<List<int>> getTicks(String contract) async {
  var headers = {
    "Accept": "application/json",
    'Content-type': 'application/json',
  };
  var url = Uri.parse(
      'https://api.ghostnet.tzkt.io/v1/contracts/$contract/bigmaps/ticks/keys');
  var res = await http.get(url, headers: headers);
  if (res.statusCode != 200) {
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  }
  List<int> list = [];
  for (var element in json.decode(res.body)) {
    if (element['active'] == true) {
      list.add(int.parse(element['key']));
    }
  }
  return list;
}

double weiToEther(BigInt wei) {
  return wei / powBigInt(BigInt.from(10), 18);
}

getCurrentTick(String contract) async {
  var headers = {
    "Accept": "application/json",
    'Content-type': 'application/json',
  };
  var url =
      Uri.parse('https://api.ghostnet.tzkt.io/v1/contracts/$contract/storage');

  var res = await http.get(url, headers: headers);
  if (res.statusCode != 200) {
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  }

  Map map = jsonDecode(res.body);
  return int.parse(map['cur_tick_index']);
}

getLiquidityFromContract(String contract) async {
  var headers = {
    "Accept": "application/json",
    'Content-type': 'application/json',
  };
  var url =
      Uri.parse('https://api.ghostnet.tzkt.io/v1/contracts/$contract/storage');

  var res = await http.get(url, headers: headers);
  if (res.statusCode != 200) {
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  }

  Map map = jsonDecode(res.body);
  return BigInt.parse(map['liquidity']);
}

getSqrtCurrentPrice(String contract) async {
  var headers = {
    "Accept": "application/json",
    'Content-type': 'application/json',
  };
  var url =
      Uri.parse('https://api.ghostnet.tzkt.io/v1/contracts/$contract/storage');

  var res = await http.get(url, headers: headers);
  if (res.statusCode != 200) {
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  }

  Map map = jsonDecode(res.body);
  return BigInt.parse(map['sqrt_price']);
}

getFeeFromContract(String contract) async {
  var headers = {
    "Accept": "application/json",
    'Content-type': 'application/json',
  };
  var url =
      Uri.parse('https://api.ghostnet.tzkt.io/v1/contracts/$contract/storage');

  var res = await http.get(url, headers: headers);
  if (res.statusCode != 200) {
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  }

  Map map = jsonDecode(res.body);
  return double.parse(map['constants']['fee_bps']);
}

getLiquidity(double y, double x, int pl, int pu, int currentTick) {
  var pc = pow(1.0001, currentTick);
  if (pc < pl) {
    // Liq = dx/ (  (1/sqrt(Pl))   -   (1/sqrt(Pc))   )
    return x / ((1 / sqrt(pl)) - (1 / sqrt(pu))) * 0.9999;
  } else if (pu < pc) {
    //Liq= dy/( sqrt(Pc) - sqrt(Pl) )
    return y / (sqrt(pu) - sqrt(pl)) * 0.9999;
  } else {
    var xLiquidity =
        (x * ((sqrt(pu) * sqrt(pc)) / (sqrt(pu) - sqrt(pc)))) * 0.9999;
    var yLiquidity = ((y) / (sqrt(pc) - sqrt(pl))) * 0.9999;
    if (xLiquidity < yLiquidity) {
      return xLiquidity;
    } else {
      return yLiquidity;
    }
  }
}

///Calculate the amount of X or Y given one of the two
Future<double> calcSecondTokenAmount(
    double amount, int decimals, int pl, int pu, String contract,
    {bool isY = false}) async {
  var currentTick = await getCurrentTick(contract);
  var pc = pow(1.0001, currentTick);
  if (isY) {
    var liquidity =
        await getLiquidity(amount, amount * 2 * pc, pl, pu, currentTick);
    double res = liquidity * (sqrt(pu) - sqrt(pc) / sqrt(pu) * sqrt(pc)) * 1.01;
    if (res < 0) {
      res = 0;
    }

    return res.toPrecision(3);
  } else {
    var liquidity =
        await getLiquidity(amount * 2 * pc, amount, pl, pu, currentTick);
    double res = liquidity * (sqrt(pc) - sqrt(pl)) * 1.01;
    if (res < 0) {
      res = 0;
    }

    return res.toPrecision(3);
  }
}

///Calculate the amount of X or Y given one of the two
Future<double> calcSecondTokenAmountSwap(
    double amount, int decimals, String contract, bool yToX) async {
  var fee = await getFeeFromContract(contract);
  fee = 1 - (fee / 10000);

  var liquidity = await getLiquidityFromContract(contract);
  var sqcp = await getSqrtCurrentPrice(contract);
  BigInt pn = BigInt.zero;
  if (yToX) {
    var priceDiff =
        (etherToWei(amount, decimals) * powBigInt(BigInt.from(2), 80)) ~/
            liquidity;
    pn = sqcp + priceDiff;

    if (sqcp < pn) {
      //(liq * q80 * (pb - pa) / pa / pb)
      BigInt res =
          liquidity * powBigInt(BigInt.from(2), 80) * (pn - sqcp) ~/ sqcp ~/ pn;
      return (weiToEther(res) * fee);
    } else {
      BigInt res =
          liquidity * powBigInt(BigInt.from(2), 80) * (sqcp - pn) ~/ pn ~/ sqcp;
      return (weiToEther(res) * fee);
    }
  } else {
    pn = (liquidity * powBigInt(BigInt.from(2), 80) * sqcp) ~/
        (liquidity * powBigInt(BigInt.from(2), 80) +
            etherToWei(amount, decimals) * sqcp);

    if (sqcp < pn) {
      BigInt res = liquidity * (pn - sqcp) ~/ powBigInt(BigInt.from(2), 80);
      return (weiToEther(res) * fee);
    } else {
      BigInt res = liquidity * (sqcp - pn) ~/ powBigInt(BigInt.from(2), 80);
      return (weiToEther(res) * fee);
    }
  }
}

powBigInt(BigInt x, int exponent) {
  var res = x;
  for (var i = 0; i < exponent - 1; i++) {
    res = res * x;
  }
  return res;
}

Future<bool> checkIfOperator(
    String tokenContract, String userAddress, String swapContract) async {
  var headers = {
    "Accept": "application/json",
    'Content-type': 'application/json',
  };
  var url = Uri.parse(
      'https://api.ghostnet.tzkt.io/v1/contracts/$tokenContract/bigmaps/operators/keys');
  var res = await http.get(url, headers: headers);
  if (res.statusCode != 200) {
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  }
  List list = json.decode(res.body);
  var allreadyOperator = list.any((element) =>
      element['key']['address_0'] == userAddress &&
      element['key']['address_1'] == swapContract);
  return allreadyOperator;
}

getPositions(String contractAddress) async {
  var headers = {
    "Accept": "application/json",
    'Content-type': 'application/json',
  };
  var url = Uri.parse(
      'https://api.ghostnet.tzkt.io/v1/contracts/$contractAddress/bigmaps/positions/keys');
  var res = await http.get(url, headers: headers);
  if (res.statusCode != 200) {
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  }

  return res.body;
}

Future<List<Map>> positionsOfAddress(
    String address, String contractAddress) async {
  var positions = await getPositions(contractAddress);
  List<Map> myPositions = [];

  for (Map position in json.decode(positions)) {
    if (position['value']['owner'] == address && position['active'] == true) {
      myPositions.add(position);
    }
  }
  return myPositions;
}

Future<List<ChartDatapoint>> buildChartPoints(String contractAddress) async {
  List positionsMaps = json.decode(await getPositions(contractAddress));
  List<ChartDatapoint> dataPoints = [];
  var activePositions =
      positionsMaps.where((element) => element['active'] == true);

  Map<int, List> points;

  for (var position in activePositions) {
    int max =
        pow(1.0001, int.parse(position['value']['upper_tick_index'])).toInt();
    int min =
        pow(1.0001, int.parse(position['value']['lower_tick_index'])).toInt();
    int liquidity =
        smallToFull(BigInt.parse(position['value']['liquidity']), 18).toInt();
    for (var i = min; i < max; i++) {
      var index = dataPoints.indexWhere((element) => element.x == i);
      if (index == -1) {
        dataPoints
            .add(ChartDatapoint(x: i.toDouble(), y: liquidity.toDouble()));
      } else {
        dataPoints[index].y = dataPoints[index].y + liquidity.toDouble();
      }
    }
  }

  dataPoints.sort((a, b) => a.x.compareTo(b.x));

  return dataPoints;
}

Future<List<ChartDatapoint>> buildChartPoints2(
    String contractAddress, int from, int to) async {
  ChartDatapoint(x: 11, y: 3.4);
  List positionsMaps = json.decode(await getPositions(contractAddress));

  List<Range> ranges = [];
  List<ChartDatapoint> dataPoints = [];
  var activePositions =
      positionsMaps.where((element) => element['active'] == true);
  print(activePositions.length);

  for (var position in activePositions) {
    int max =
        pow(1.0001, int.parse(position['value']['upper_tick_index'])).toInt();
    int min =
        pow(1.0001, int.parse(position['value']['lower_tick_index'])).toInt();
    int liquidity =
        smallToFull(BigInt.parse(position['value']['liquidity']), 18).toInt();
    Range currentRange = Range(liquidity, max, min);
    var a = 0;
    var rangesOld = ranges;
    for (var range in rangesOld) {
      a++;
      print(a);
      ranges.add(currentRange);
      // if (currentRange.min == range.min && currentRange.max == range.max) {
      //   ranges.remove(range);
      //   ranges.add(Range(currentRange.liquidity + range.liquidity, max, min));
      // } else {
      //   if (currentRange.min < range.max && currentRange.min > range.min) {
      //     //new range completly in other range
      //     if (currentRange.max < range.max) {
      //       ranges.remove(range);
      //       ranges.add(Range(range.liquidity, currentRange.min - 1, range.min));
      //       ranges.add(Range(currentRange.liquidity + range.liquidity,
      //           currentRange.max, currentRange.min));
      //       ranges.add(Range(range.liquidity, range.max, currentRange.max + 1));
      //     } else {
      //       //new range clips from right side
      //       ranges.remove(range);
      //       ranges.add(Range(range.liquidity, currentRange.min - 1, range.min));
      //       ranges.add(Range(currentRange.liquidity + range.liquidity,
      //           range.max, currentRange.min));
      //       ranges.add(Range(range.liquidity, range.max + 1, currentRange.max));
      //     }
      //   } else if (currentRange.min < range.min &&
      //       currentRange.max > range.min) {
      //     //new range clips from left side
      //     ranges.remove(range);
      //     ranges
      //         .add(Range(currentRange.liquidity, currentRange.min, range.min));
      //     ranges.add(Range(currentRange.liquidity + range.liquidity, range.min,
      //         currentRange.max));
      //     ranges.add(Range(range.liquidity, currentRange.max + 1, range.max));
      //   } else {
      //     ranges.add(currentRange);
      //   }
      // }
    }

    if (ranges.isEmpty) {
      ranges.add(currentRange);
    }
  }
  var end = 0;
  var index = 0;
  var start = ranges.indexWhere((element) => element.min < from);
  index = start;
  if (start == -1) {
    print('done-1');
    return dataPoints;
  }
  print('while');
  while (from < end && index <= ranges.last.max) {
    var range = ranges[index];
    end = range.max;
    index++;
    for (var i = range.min; i < range.max; i++) {
      dataPoints
          .add(ChartDatapoint(x: i.toDouble(), y: range.liquidity.toDouble()));
    }
  }
  print('done');
  return dataPoints;
}

class Range {
  Range(this.liquidity, this.max, this.min);
  final int liquidity;
  final int max;
  final int min;
}

List<Token> getContractTokens(String contractAddress) {
  var contracts = Get.put(ContractService()).contracts;
  var contract =
      contracts.firstWhere((element) => element.address == contractAddress);
  List<Token> tokens = [];
  var tokenRepo = Get.put(TokenService()).tokens;
  tokens.addAll(tokenRepo.where((element) =>
      element.tokenAddress == contract.tokenX ||
      element.tokenAddress == contract.tokenY));
  return tokens;
}

String addressToDisplayAddress(String address) {
  return '${address.substring(0, 7)}....${address.substring(32)}';
}

double smallToFull(BigInt amount, int decimal) {
  return amount / BigInt.from(pow(10, decimal));
}

BigInt sqrtBigInt(BigInt x) {
  if (x == BigInt.zero || x == BigInt.one) {
    return x;
  }

  BigInt start = BigInt.one;
  BigInt end = x;

  while (start + BigInt.one < end) {
    BigInt mid = start + (end - start) ~/ BigInt.two;
    if (mid == x ~/ mid) {
      return mid;
    } else if (mid > x ~/ mid) {
      end = mid;
    } else {
      start = mid;
    }
  }
  return start;
}
