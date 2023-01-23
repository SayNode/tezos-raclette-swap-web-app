// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanoid/nanoid.dart';
import 'package:tezos_swap_frontend/utils/globals.dart' as global;
import 'package:tezos_swap_frontend/utils/utils.dart';

import '../models/contract_model.dart';
import '../pages/widgets/card_route.dart';
import '../pages/widgets/card_route_not dismissable.dart';
import '../pages/widgets/select_token_card.dart';
import '../theme/ThemeRaclette.dart';

class WalletService extends GetxService {
  RxString address = ''.obs;
  RxBool connected = false.obs;

  authorize(String tokenContract, String swapContract) async {
    bool isOp =
        await checkIfOperator(tokenContract, address.value, swapContract);

    if (isOp) {
      String id = nanoid();
      html.window.addEventListener("message", (event) {
        final evt = (event as html.MessageEvent);
        if (evt.source == html.window &&
            evt.data['reqId'] == id &&
            evt.data['type'] == 'TEMPLE_PAGE_RESPONSE') {
          Get.close(1);
        }
      }, true);
      var done = await Navigator.of(Get.context!).push(CardDialogRouteNoDismiss(
          builder: (context) {
            authorizeContract(tokenContract, swapContract, id);
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 400,
                  height: 500,
                  child: Card(
                    color: ThemeRaclette.primaryStatic,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: const Center(
                      child: Text('Waiting for authorization.'),
                    ),
                  ),
                ),
              ),
            );
          },));
    }
  }

  requestPermission() {
    _request({
      "type": "PERMISSION_REQUEST",
      "network": global.network,
      "appMeta": {"name": "TezosSwap"},
      "force": true
    });
  }

//FIXME: might be problems with tokenx and y amount calculation
  swap(String contract, String recipient, double tokenX, double tokenY,
      String tokenXAddress, String tokenYAddress,
      {bool yToX = false}) {
    String entrypoint = "x_to_y";
    if (yToX) {
      entrypoint = "y_to_x";
    }
    authorize(contract, tokenXAddress);
    authorize(contract, tokenYAddress);
    print('Token X: $tokenX');
    print(tokenX.runtimeType);
    BigInt x = etherToWei(tokenX, 18);
    BigInt y = etherToWei(tokenY, 18);
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
                    {"int": "$x"}
                  ]
                },
                {
                  "prim": "Pair",
                  "args": [
                    {"int": "$y"},
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
    int lowerPrice,
    int upperPrice,
    String tokenXAddress,
    String tokenYAddress,
  ) async {
    authorize(contract, tokenXAddress);
    authorize(contract, tokenYAddress);
    var ticks = await getTicks(contract);
    var lowerTick = logBase(lowerPrice, 1.0001);
    var upperTick = logBase(upperPrice, 1.0001);
    var lowerWitness = ticks.where((e) => e <= lowerTick).toList()
      ..sort()
      ..last;
    var upperWitness = ticks.where((e) => e <= upperTick).toList()
      ..sort()
      ..last;

    var currentTick = await getCurrentTick(contract);

    BigInt liquidity = etherToWei(await getLiquidity(
        yDouble, xDouble, lowerPrice, upperPrice, currentTick), 18);


    BigInt x = etherToWei(xDouble, 18);
    BigInt y = etherToWei(yDouble, 18);
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
                        {"int": "${lowerTick.toInt()}"},
                        {"int": '-1048575'}
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
                        {"int": "${upperTick.toInt()}"}
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

  authorizeContract(
      String tokenContract, String swapContract, String id) async {
    _request({
      "type": "OPERATION_REQUEST",
      "sourcePkh": 'tz1NyKro1Qi2cWd66r91BwByT5gxyBoWSrFf',
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
    }, id: id);
  }

  removePosition(String contract, Map position) async {
    print(position['key']);
    var liquidity = '-${position['value']['liquidity']}';

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
                        {"int": liquidity}
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
                        {"int": position['key']}
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

  _request(Map payload, {String? id}) {
    id ??= nanoid();
    var msg = {'type': 'TEMPLE_PAGE_REQUEST', 'payload': payload, 'reqId': id};
    html.window.postMessage(msg, "*");

    html.window.addEventListener("message", (event) {
      final evt = (event as html.MessageEvent);
      if (evt.source == html.window &&
          evt.data['reqId'] == id &&
          evt.data['type'] == 'TEMPLE_PAGE_RESPONSE') {
        address.value = evt.data['payload']['pkh'];
      } else if (evt.source == html.window &&
          evt.data['reqId'] == id &&
          evt.data['type'] == 'TEMPLE_PAGE_ERROR_RESPONSE') {
        print('-----------');
        print(evt.data);
        print('-----------');
      }
    }, true);
  }
}
