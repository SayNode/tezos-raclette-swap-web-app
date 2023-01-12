// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanoid/nanoid.dart';
import 'package:tezos_swap_frontend/utils/globals.dart' as global;
import 'package:tezos_swap_frontend/utils/utils.dart';

import '../models/contract_model.dart';

class WalletProvider extends ChangeNotifier {
  RxString address = ''.obs;

  requestPermission() {
    _request({
      "type": "PERMISSION_REQUEST",
      "network": global.network,
      "appMeta": {"name": "TezosSwap"},
      "force": true
    });
  }

//FIXME: might be problems with tokenx and y amount calculation
  swap(String contract, String recipient, BigInt tokenX, BigInt tokenY,
      {bool yToX = false}) {
    String entrypoint = "x_to_y";
    if (yToX) {
      entrypoint = "y_to_x";
    }
    _request({
      "type": "OPERATION_REQUEST",
      "sourcePkh": recipient,
      "opParams": [
        {
          "kind": "transaction",
          "to": contract,
          "amount": 0,
          "mutez": true,
          "parameter": {
            "entrypoint": entrypoint,
            "value": {
              "prim": "Pair",
              "args": [
                {
                  "prim": "Pair",
                  "args": [
                    {"string": "2023-09-20T10:19:24Z"}, //TODO: set date
                    {"int": "$tokenX"}
                  ]
                },
                {
                  "prim": "Pair",
                  "args": [
                    {"int": "$tokenY"},
                    {"string": recipient}
                  ]
                }
              ]
            }
          }
        }
      ]
    });
  }

  double logBase(int x, double base) => log(x) / log(base);

  setPosition(
    String contract,
    String signer,
    double xDouble,
    double yDouble,
    double liquidityDouble,
    int lowerPrice,
    int upperPrice,
  ) async {
    var ticks = await getTicks(contract);
    var lowerTick = logBase(lowerPrice, 1.0001);
    var upperTick = logBase(upperPrice, 1.0001);
    var lowerWitness = ticks.where((e) => e <= lowerTick).toList()
      ..sort()
      ..last;
    var upperWitness = ticks.where((e) => e <= upperTick).toList()
      ..sort()
      ..last;
    BigInt liquidity = fractionToFullToken(liquidityDouble, 18);
    BigInt x = fractionToFullToken(xDouble, 18);
    BigInt y = fractionToFullToken(yDouble, 18);

    print(lowerWitness);
    print(upperWitness);

    _request({
      "type": "OPERATION_REQUEST",
      "sourcePkh": signer,
      "opParams": [
        {
          "kind": "transaction",
          "to": contract,
          "amount": 0,
          "mutez": true,
          "parameter": {
            "entrypoint": "set_position",
            "value": {
              "prim": "Pair",
              "args": [
                {
                  "prim": "Pair",
                  "args": [
                    {
                      "prim": "Pair",
                      "args": [
                        {"int": "2665581460"}, //TODO: set deadline
                        {"int": "$liquidity"}
                      ]
                    },
                    {
                      "prim": "Pair",
                      "args": [
                        {"int": "$lowerTick"},
                        {"int": "${lowerWitness.last}"}
                      ]
                    }
                  ]
                },
                {
                  "prim": "Pair",
                  "args": [
                    {
                      "prim": "Pair",
                      "args": [
                        {
                          "prim": "Pair",
                          "args": [
                            {"int": "$x"},
                            {"int": "$y"}
                          ]
                        },
                        {"int": "$upperTick"}
                      ]
                    },
                    {"int": "${upperWitness.last}"}
                  ]
                }
              ]
            }
          }
        }
      ]
    });
  }

  authorizeContract(String tokenContract, String swapContract) async {
    _request({
      "type": "OPERATION_REQUEST",
      "sourcePkh": address.value,
      "opParams": [
        {
          "kind": "transaction",
          "to": tokenContract,
          "amount": 0,
          "mutez": true,
          "parameter": {
            "entrypoint": "update_operators",
            "value": [
              {
                "prim": "Left",
                "args": [
                  {
                    "prim": "Pair",
                    "args": [
                      {"string": address.value},
                      {
                        "prim": "Pair",
                        "args": [
                          {"string": swapContract},
                          {"int": "0"}
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          }
        }
      ]
    });
  }

  removePosition(String contract, String position) async {
    _request({
      "type": "OPERATION_REQUEST",
      "sourcePkh": address.value,
      "opParams": [
        {
          "kind": "transaction",
          "to": contract,
          "amount": 0,
          "mutez": true,
          "parameter": {
            "entrypoint": "update_position",
            "value": {
              "prim": "Pair",
              "args": [
                {
                  "prim": "Pair",
                  "args": [
                    {
                      "prim": "Pair",
                      "args": [
                        //TODO: do proper deadline
                        {"int": "2668508020"},
                        {"int": "0"}
                      ]
                    },
                    {
                      "prim": "Pair",
                      "args": [
                        {
                          "prim": "Pair",
                          "args": [
                            {"int": "0"},
                            {"int": "0"}
                          ]
                        },
                        {"int": position}
                      ]
                    }
                  ]
                },
                {
                  "prim": "Pair",
                  "args": [
                    {"string": address.string},
                    {"string": address.string}
                  ]
                }
              ]
            }
          }
        }
      ]
    });
  }

  _request(Map payload) {
    String id = nanoid();
    var msg = {'type': 'TEMPLE_PAGE_REQUEST', 'payload': payload, 'reqId': id};
    html.window.postMessage(msg, "*");

    html.window.addEventListener("message", (event) {
      final evt = (event as html.MessageEvent);
      if (evt.source == html.window &&
          evt.data['reqId'] == id &&
          evt.data['type'] == 'TEMPLE_PAGE_RESPONSE') {
        address.value = evt.data['payload']['pkh'];
        notifyListeners();
      } else if (evt.source == html.window &&
          evt.data['reqId'] == id &&
          evt.data['type'] == 'TEMPLE_PAGE_ERROR_RESPONSE') {
        print(evt.data);
      }
    }, true);
  }
}
