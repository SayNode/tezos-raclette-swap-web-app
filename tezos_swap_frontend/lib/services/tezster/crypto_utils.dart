import 'dart:typed_data';

import 'package:tezos_swap_frontend/services/tezster/sodium_utils_web.dart';

class CryptoUtils {
  static final _sodium = getSodium();
  static Uint8List generateSaltForPwHash() {
    return _sodium.salt();
  }

  static Uint8List encryptMessage(
      Uint8List message, String passphrase, Uint8List salt) {
    var keyBytes = _sodium.pwhash(passphrase, salt);
    var nonce = _sodium.nonce();
    var s = _sodium.close(message, nonce, keyBytes);

    return new Uint8List.fromList(nonce.toList() + s.toList());
  }

  static Uint8List decryptMessage(message, passphrase, salt) {
    var keyBytes = _sodium.pwhash(passphrase, salt);
    return _sodium.open(message, keyBytes);
  }

  static Uint8List signDetached(Uint8List simpleHash, Uint8List key) {
    return _sodium.sign(simpleHash, key);
  }
}
