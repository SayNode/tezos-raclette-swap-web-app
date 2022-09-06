import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

double roundDouble(double value, int places) {
  double mod = pow(10.0, places) as double;
  return ((value * mod).round().toDouble() / mod);
}

forgeOperation() async {
  var headers = {
    'accept': 'application/json',
    'Content-type': 'application/json',
  };
  String data= json.encode({
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
  });

  var url = Uri.parse(
      'https://jakartanet.smartpy.io/chains/main/blocks/head/helpers/forge/operations');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode != 200) {
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  }
  print(res.body);
}
