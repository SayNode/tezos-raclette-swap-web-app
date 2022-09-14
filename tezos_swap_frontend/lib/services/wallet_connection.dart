// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanoid/nanoid.dart';
import 'package:tezos_swap_frontend/utils/globals.dart' as global;
import 'package:tezos_swap_frontend/utils/utils.dart';

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

  requestSigning(String rawTx) {
    _request({
      "type": "OPERATION_REQUEST",
      "sourcePkh": "tz1LPSEaUzD1V6Qu3TAi6iCiktRGF1t2up4Z",
      "payload": [
        {
          "kind": "transaction",
          "counter": "1352785",
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
                    {"string": "2022-09-20T10:19:24Z"},
                    {"int": "5"}
                  ]
                },
                {
                  "prim": "Pair",
                  "args": [
                    {"int": "3"},
                    {"string": "tz1LPSEaUzD1V6Qu3TAi6iCiktRGF1t2up4Z"}
                  ]
                }
              ]
            }
          }
        }
      ]
    }
        /*
      
      {
      "kind": "transaction",
      "counter": "1352785",
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
                {"string": "2022-09-20T10:19:24Z"},
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
    */
        );
  }

  swap(String addressX, String addressY) async {
    var raw = await forgeSwap(addressX, addressY);
    print(raw);
    await requestSigning(raw);
    print('done');
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
