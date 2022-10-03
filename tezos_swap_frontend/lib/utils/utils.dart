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



Future<List<int>> getTicks(String contract) async {
  var headers = {
    "Accept": "application/json",
    'Content-type': 'application/json',
  };
  var url = Uri.parse(
      'https://api.jakartanet.tzkt.io/v1/contracts/$contract/bigmaps/ticks/keys');
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

Future<bool> isAuthorized(String tokenContract, String userAddress, String swapContract) async {
  var headers = {
    "Accept": "application/json",
    'Content-type': 'application/json',
  };
  var url = Uri.parse(
      'https://api.jakartanet.tzkt.io/v1/contracts/$tokenContract/bigmaps/operators/keys');
  var res = await http.get(url, headers: headers);
  if (res.statusCode != 200) {
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  }
  List list =json.decode(res.body);
  var allreadyOperator = list.any((element) => element['key']['address_0']==userAddress&&element['key']['address_1']==swapContract);
  return allreadyOperator;
  
}

getPositions(String contractAddress) async {
  var headers = {
    "Accept": "application/json",
    'Content-type': 'application/json',
  };
  var url = Uri.parse(
      'https://api.jakartanet.tzkt.io/v1/contracts/$contractAddress/bigmaps/positions/keys');
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
    if (position['value']['owner'] == address) {
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

String addressToDisplayAddress(String address) {
  //tz1NyKro1Qi2cWd66r91BwByT5gxyBoWSrFf
  return '${address.substring(0, 7)}....${address.substring(32)}';
}

List<Token>  getContractTokens(String contractAddress)  {
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
