import 'dart:html' as html;
import 'package:flutter/material.dart';

class WalletProvider extends ChangeNotifier {


  connect(Map payload) {
    var msg = {
      'type': 'TEMPLE_PAGE_REQUEST',
      'payload': payload,
      'reqId': 'TS4EhXBOb4xYPnF35FB4Q'
    };
    html.window.postMessage(msg, "*");

    html.window.addEventListener("message", (event) {
      listen(event);
    }, true);
  }

  void listen(html.Event event) {
    var data = (event as html.MessageEvent).data;
    print('yes');
    print(data['sender']);
    print(data['message']);
  }
}
