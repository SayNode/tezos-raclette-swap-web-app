part of ethereum;

@JS("BinanceChain")
external _EthereumImpl? get _binanceChain;

@JS("ethereum")
external _EthereumImpl? get _ethereum;

@deprecated
@JS("web3")
external _EthereumImpl? get _web3;

@JS("window")
external Object get _window;

@JS()
@anonymous
class _AddEthereumChainParameterImpl {
  external factory _AddEthereumChainParameterImpl({
    required String chainId,
  });

  external String get chainId;
}

@JS()
@anonymous
class _ChainParamsImpl {
  external factory _ChainParamsImpl({
    required String chainId,
    required String chainName,
    required List<String> rpcUrls,
    List<String>? blockExplorerUrls,
  });

  external List<String> get blockExplorerUrls;

  external String get chainId;

  external String get chainName;

  external List<String> get rpcUrls;
}

@JS()
@anonymous
class _EthereumImpl {

}

@JS()
@anonymous
class _RequestArgumentsImpl {
  external factory _RequestArgumentsImpl({
    required String method,
    dynamic params,
  });

  external String get method;

  external dynamic get params;
}