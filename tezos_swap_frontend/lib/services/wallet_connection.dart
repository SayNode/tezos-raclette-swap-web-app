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

  swap(String contract, String recipient, int tokenX, int tokenY,
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

  setPosition(
    String contract,
    String signer,
    int x,
    int y,
    int lowerTick,
    int upperTick,
  ) async {
    var ticks = await getTicks();
    var lowerWitness = ticks.where((e) => e <= lowerTick).toList()
      ..sort()
      ..last;
    var upperWitness = ticks.where((e) => e <= upperTick).toList()
      ..sort()
      ..last;

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
                        {"int": "1665581460"},//TODO: set deadline
                        {"int": "${sqrt(x * y)}"}
                      ]
                    },
                    {
                      "prim": "Pair",
                      "args": [
                        {"int": "$lowerTick"},
                        {"int": "${lowerWitness[0]}"}
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
                    {"int": "${upperWitness[0]}"}
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
