import 'dart:convert';
import 'dart:js_util';
import 'package:flutter/cupertino.dart';
import 'package:tezos_swap_frontend/services/ethereum.dart';
import '../abc.dart';
import 'dart:html' as html;

class WalletProvider extends ChangeNotifier {
  connectMetamask() async {
    final accs = await ethereum!.requestAccount();
  }

connect(String payload) {
    var id = "V1StGXR8_Z5jdHi6B-myT";
  var type = "TEMPLE_PAGE_REQUEST";
  var msg = "{type, payload, id}";


  html.window.postMessage(msg, "*");

}

  void listen(html.Event event) {
    var data = (event as html.MessageEvent).data;
    print(data['sender']);
    print(data['message']);
  }
}
