import 'dart:convert';
import 'dart:math';
import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/chart_datapoint.dart';
import 'globals.dart' as global;

double roundDouble(double value, int places) {
  double mod = pow(10.0, places) as double;
  return ((value * mod).round().toDouble() / mod);
}

Future<String> forgeSwap(String adressX, String addressY) async {
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
        "source": "tz1LPSEaUzD1V6Qu3TAi6iCiktRGF1t2up4Z",
        "amount": "0",
        "destination": "KT1G49NuztmWBP6sMFZM259RCkg6eeFpbYp7",
        "parameters": {
          "entrypoint": "x_to_y",
          "value": {
            "prim": "Pair",
            "args": [
              {
                "prim": "Pair",
                "args": [
                  {"int": "1663062513"},
                  {"int": "10"}
                ]
              },
              {
                "prim": "Pair",
                "args": [
                  {"int": "8"},
                  {"string": "tz1LPSEaUzD1V6Qu3TAi6iCiktRGF1t2up4Z"}
                ]
              }
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

Future<List<int>> getTicks() async {
  var headers = {
    "Accept": "application/json",
    'Content-type': 'application/json',
  };
  var url = Uri.parse(
      'https://api.jakartanet.tzkt.io/v1/contracts/KT1G49NuztmWBP6sMFZM259RCkg6eeFpbYp7/bigmaps/ticks/keys');
  var res = await http.get(url, headers: headers);
  if (res.statusCode != 200) {
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  }
  print(res.body);
  List<int> list = [];
  for (var element in json.decode(res.body)) {
    list.add(int.parse(element['key']));
  }
  return list;
}

getPositions() async {
  var headers = {
    "Accept": "application/json",
    'Content-type': 'application/json',
  };
  var url = Uri.parse(
      'https://api.jakartanet.tzkt.io/v1/contracts/KT1G49NuztmWBP6sMFZM259RCkg6eeFpbYp7/bigmaps/positions/keys');
  var res = await http.get(url, headers: headers);
  if (res.statusCode != 200) {
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  }

  return res.body;
}

Future<List<ChartDatapoint>> buildChartPoints() async {
  ChartDatapoint(x: 11, y: 3.4);
  List positionsMaps = json.decode(await getPositions());
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
