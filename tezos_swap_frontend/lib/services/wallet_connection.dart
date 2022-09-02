// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanoid/nanoid.dart';

class WalletProvider extends ChangeNotifier {
  RxString address = ''.obs;

  requestPermission() {
    _request({
      "type": "PERMISSION_REQUEST",
      "network": "jakartanet",
      "appMeta": {"name": "TezosSwap"},
      "force": true
    });
  }

  requestTransaction(int amount, String caller, String contract,) {
    _request({
      "type": "OPERATION_REQUEST",
      "sourcePkh": caller,
      "opParams": [
        {
          "kind": "transaction",
          "to": contract,
          "amount": amount * 1000000,
          "mutez": true,
          "parameter": {
            "entrypoint": "tezToTokenPayment",
            "value": {
              "prim": "Pair",
              "args": [
                //TODO: calc slippage
                {"int": "100"},
                {"string": caller}
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
          evt.data['type'] == 'TEMPLE_PAGE_ERROR_RESPONSE') {}
    }, true);
  }
}