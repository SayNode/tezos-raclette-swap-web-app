@JS("window")
library ethereum;
import 'package:js/js.dart';
import 'package:js/js_util.dart';
import './utils.dart';
import './interop_wrapper.dart';
import 'exception.dart';
part 'interop.dart';

/// Getter for default Ethereum object, cycles through available injector in environment.
Ethereum? get ethereum => Ethereum.provider;

/// Interface for connection info used by [Ethereum] method.
@JS()
@anonymous
class ConnectInfo {
  /// Chain id in hex that is currently connected to.
  external String get chainId;
}
/// A Dart Ethereum Provider API for consistency across clients and applications.
class Ethereum extends Interop<_EthereumImpl> {

  /// Modern Ethereum provider api, injected by many famous environment such as `MetaMask` or `TrustWallet`.
  static Ethereum get ethereum => Ethereum._(_ethereum!);

  /// Getter for default Ethereum provider object, cycles through available injector in environment.
  static Ethereum? get provider => true
      ? _ethereum != null
          ? Ethereum._(_ethereum!)
          : Ethereum._(_binanceChain!)
      : null;


  const Ethereum._(_EthereumImpl impl) : super.internal(impl);





  /// Returns List of accounts the node controls.
  Future<List<String>> getAccounts() async =>
      (await request<List<dynamic>>('eth_accounts'))
          .map((e) => e.toString())
          .toList();


  Future<T> request<T>(String method, [dynamic params]) async {
    try {
      switch (T) {
        case BigInt:
          return BigInt.parse(await request<String>(method, params)) as T;
        default:
          return await promiseToFuture<T>(
            callMethod(
              impl,
              'request',
              [
                _RequestArgumentsImpl(
                    method: method, params: params != null ? params : [])
              ],
            ),
          );
      }
    } catch (error) {
      final err = convertToDart(error);
      switch (err['code']) {
        case 4001:
          throw EthereumUserRejected();
        default:
          if (err['message'] != null)
            throw EthereumException(err['code'], err['message'], err['data']);
          else
            rethrow;
      }
    }
  }

  Future<List<String>> requestAccount() async =>
      (await request<List<dynamic>>('eth_requestAccounts', [])).cast<String>();


}

