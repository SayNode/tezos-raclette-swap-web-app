import 'dart:convert';
import 'dart:math';
import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/chart_datapoint.dart';
import '../models/token.dart';
import '../repositories/contract_repo.dart';
import '../repositories/token_repo.dart';
import 'globals.dart' as global;

double roundDouble(double value, int places) {
  double mod = pow(10.0, places) as double;
  return ((value * mod).round().toDouble() / mod);
}

//TODO: find better way
fractionToFullToken(num amount, int decimals) {
  print('------------');
  print(decimals);
  print(amount);
  print('------------');
  amount = amount.toDouble();
  print('to double');
  String amountString = amount.toString();

  int afterComma = 0;
  if (amountString.contains('.')) {
    afterComma = amountString.substring(amountString.indexOf('.')).length;
  }

  String addedZeros = '';
  amountString = amountString.replaceAll('.', '');

  if (decimals - afterComma < 0) {
    amountString = amountString.substring(
        0, amountString.length - (afterComma - decimals - 1));
  } else {
    for (var i = 0; i < (decimals + 1) - afterComma; i++) {
      addedZeros = '${addedZeros}0';
    }
  }

  return BigInt.parse(amountString + addedZeros);
}

// Future<String> forgeSwap(String adressX, String addressY) async {
//   var headers = {
//     "Accept": "application/json",
//     'Content-type': 'application/json',
//   };

//   var data = utf8.encode(json.encode({
//     "branch": "BMHBtAaUv59LipV1czwZ5iQkxEktPJDE7A9sYXPkPeRzbBasNY8",
//     "contents": [
//       {
//         "kind": "transaction",
//         "counter": "1274363",
//         "source": "tz1LPSEaUzD1V6Qu3TAi6iCiktRGF1t2up4Z",
//         "amount": "0",
//         "destination": "KT1G49NuztmWBP6sMFZM259RCkg6eeFpbYp7",
//         "parameters": {
//           "entrypoint": "x_to_y",
//           "value": {
//             "prim": "Pair",
//             "args": [
//               {
//                 "prim": "Pair",
//                 "args": [
//                   {"int": "1663062513"},
//                   {"int": "10"}
//                 ]
//               },
//               {
//                 "prim": "Pair",
//                 "args": [
//                   {"int": "8"},
//                   {"string": "tz1LPSEaUzD1V6Qu3TAi6iCiktRGF1t2up4Z"}
//                 ]
//               }
//             ]
//           }
//         },
//         "fee": "1420",
//         "storage_limit": "496",
//         "gas_limit": "10600"
//       }
//     ]
//   }));

//   var url = Uri.parse(
//       '${global.networkUri}/chains/main/blocks/head/helpers/forge/operations');
//   var res = await http.post(url, headers: headers, body: data);
//   if (res.statusCode != 200) {
//     throw Exception('http.post error: statusCode= ${res.statusCode}');
//   }
//   return res.body.replaceAll('"', '').replaceAll('\n', '');
// }

Future<String> forgeOperation() async {
  var headers = {
    "Accept": "application/json",
    'Content-type': 'application/json',
  };

  var data = utf8.encode(json.encode({
    "branch": "BMHBtAaUv59LipV1czwZ5iQkxEktPJDE7A9sYXPkPeRzbBasNY8",
    "contents": [
      {
        "kind": "transaction",
        "counter": "1274363",
        "source": "tz1NyKro1Qi2cWd66r91BwByT5gxyBoWSrFf",
        "amount": "0",
        "destination": "KT1NproXvHrDfc7NHyzGJhHVLf4ZMGz8pkae",
        "parameters": {
          "entrypoint": "tokens",
          "value": {
            "prim": "Right",
            "args": [
              [
                {
                  "prim": "Pair",
                  "args": [
                    {"string": "tz1NyKro1Qi2cWd66r91BwByT5gxyBoWSrFf"},
                    {
                      "prim": "Pair",
                      "args": [
                        {"int": "0"},
                        {"int": "1000005400"}
                      ]
                    }
                  ]
                }
              ]
            ]
          }
        },
        "fee": "1420",
        "storage_limit": "496",
        "gas_limit": "10600"
      }
    ]
  }));

  var url = Uri.parse(
      '${global.networkUri}/chains/main/blocks/head/helpers/forge/operations');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode != 200) {
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  }
  return res.body.replaceAll('"', '').replaceAll('\n', '');
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
    list.add(int.parse(element['key']));
  }
  return list;
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

getLiquidity(double y, double x, int lowerTick, int upperTick, int currentTick,
    int decimals) {
  var xLiquidity = fractionToFullToken(
      (x *
          ((sqrt(pow(1.0001, upperTick)) * sqrt(pow(1.0001, currentTick))) /
              (sqrt(pow(1.0001, upperTick)) - sqrt(pow(1.0001, currentTick))))),
      decimals);
  var yLiquidity = fractionToFullToken(
      ((y) / (sqrt(pow(1.0001, currentTick)) - sqrt(pow(1.0001, lowerTick)))),
      decimals);
  if (xLiquidity < yLiquidity) {
    return xLiquidity;
  } else {
    return yLiquidity;
  }
}

Future<bool> getOperators(
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
      .where((element) => element['value']['lower_tick_index'] == '-1048575');
  for (var map in positionsMaps) {
    int lower = int.parse(map['value']['lower_tick_index']);
    int upper = int.parse(map['value']['upper_tick_index']);
    int liquidity = int.parse(map['value']['liquidity']);
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
  var contracts = Get.put(ContractRepository()).contracts;
  var contract =
      contracts.firstWhere((element) => element.address == contractAddress);
  List<Token> tokens = [];
  var tokenRepo = Get.put(TokenRepository()).tokens;
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
