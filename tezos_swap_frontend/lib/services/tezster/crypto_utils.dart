import 'dart:typed_data';
import 'package:tezos_swap_frontend/services/tezster/sodium_utils.dart';

class CryptoUtils {
  static Future<Uint8List> generateSaltForPwHash() async {
    return SodiumUtils.salt();
  }

  static Future<Uint8List> encryptMessage(
      Uint8List message, String passphrase, Uint8List salt) async {
    var keyBytes = await SodiumUtils.pwhash(passphrase, salt);
    var nonce = await SodiumUtils.nonce();
    var s = await SodiumUtils.close(message, nonce, keyBytes);

    return Uint8List.fromList(nonce.toList() + s.toList());
  }

  static Future<Uint8List> decryptMessage(message, passphrase, salt) async {
    var keyBytes = await SodiumUtils.pwhash(passphrase, salt);
    return SodiumUtils.open(message, keyBytes);
  }

  static Future<Uint8List> signDetached(
      Uint8List simpleHash, Uint8List key) async {
    return await SodiumUtils.sign(simpleHash, key);
  }
}
