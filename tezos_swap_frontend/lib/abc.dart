import 'package:js/js.dart';

@JS("window")
@anonymous
class RequestArgumentsImpl {
  external factory RequestArgumentsImpl({
    required String method,
    dynamic params,
  });

  external String get method;

  external dynamic get params;
}

@JS()
@anonymous
class EthereumImpl {
  external set autoRefreshOnNetworkChange(bool b);

  external String get chainId;

  @deprecated
  external String? get selectedAddress;

  external bool isConnected();

  external int listenerCount([String? eventName]);

  external List<dynamic> listeners(String eventName);

  external removeAllListeners([String? eventName]);
}
