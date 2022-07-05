// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';

class WalletProvider extends ChangeNotifier {
  String address = 'Not Connected';

  requestPermission() {
    _request({
      "type": "PERMISSION_REQUEST",
      "network": "mainnet",
      "appMeta": {"name": "TezosSwap"},
      "force": true
    });
  }

  _request(Map payload) {
    String id = 'TS4EhXBOb4xYPnF35FB4Q';
    var msg = {'type': 'TEMPLE_PAGE_REQUEST', 'payload': payload, 'reqId': id};
    html.window.postMessage(msg, "*");

    html.window.addEventListener("message", (event) {
      final evt = (event as html.MessageEvent);
      if (evt.source == html.window &&
          evt.data['reqId'] == id &&
          evt.data['type'] == 'TEMPLE_PAGE_RESPONSE') {
        address = evt.data['payload']['pkh'] as String;
        notifyListeners();
      } else if (evt.source == html.window &&
          evt.data['reqId'] == id &&
          evt.data['type'] == 'TEMPLE_PAGE_ERROR_RESPONSE') {
      }
    }, true);
  }
}
