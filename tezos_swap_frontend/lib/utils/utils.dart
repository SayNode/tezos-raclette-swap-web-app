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
  return wei / BigInt.from(pow(10, 18));
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

    var liquidity = await getLiquidity(amount, amount*2*pc, pl, pu, currentTick);
    double res = liquidity * (sqrt(pu) - sqrt(pc) / sqrt(pu) * sqrt(pc))*1.01;
    if (res<0) {
      res = 0;
    }
    
    return res.toPrecision(3);
  } else {
    var liquidity = await getLiquidity(amount*2*pc, amount, pl, pu, currentTick);
    double res = liquidity * (sqrt(pc) - sqrt(pl))*1.01;
        if (res<0) {
      res = 0;
    }
    
    return res.toPrecision(3);
  }
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
  ChartDatapoint(x: 11, y: 3.4);
  List positionsMaps = json.decode(await getPositions(contractAddress));





  List<int> keys = [];
  List<ChartDatapoint> dataPoints = [];
  Map range = {};
  positionsMaps
      .where((element) => element['value']['lower_tick_index'] == '-1048575'&&element['active']==true);
  for (var map in positionsMaps) {
    int lower = int.parse(map['value']['lower_tick_index']);
    int upper = int.parse(map['value']['upper_tick_index']);
    int liquidity = smallToFull(BigInt.parse(map['value']['liquidity']), 18).toInt();
    if (lower != -1048575) {
      for (var i = lower; i <= upper; i++) {
        //FIXME: * liquidity correct?
        if (range.containsKey('$i')) {
          range['$i'] = range['$i'] + liquidity;
        } else {
          range['$i'] = liquidity;
          keys.add(i);
        }
      }
    }
  }
  for (var key in keys) {
    dataPoints.add(ChartDatapoint(x: key.toDouble(), y: range['$key']));
  }
  dataPoints.sort((a, b) => a.x.compareTo(b.x));
  return dataPoints;
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
