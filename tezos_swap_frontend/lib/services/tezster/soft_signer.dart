import 'dart:typed_data';

import 'package:tezos_swap_frontend/services/tezster/crypto_utils.dart';
import 'package:tezos_swap_frontend/services/tezster/password_generater.dart';
import 'package:tezos_swap_frontend/services/tezster/tezos_message_utils.dart';

enum SignerCurve { ED25519, SECP256K1, SECP256R1 }

class SoftSigner {
  var _secretKey;
  var _lockTimout;
  var _passphrase;
  var _salt;
  var _unlocked;
  var _key;

  SoftSigner(
      {required Uint8List secretKey,
      int validity = -1,
      String passphrase = '',
      Uint8List? salt}) {
    this._secretKey = secretKey;
    this._lockTimout = validity;
    this._passphrase = passphrase;
    this._salt = salt != null ? salt : Uint8List(0);
    this._unlocked = validity < 0;
    this._key = Uint8List(0);
    if (validity < 0) {
      this._key = secretKey;
    }
  }

  static Future<SoftSigner> createSigner(
      Uint8List secretKey, int validity) async {
    if (validity >= 0) {
      var passphrase = PasswordGenerator.generatePassword(
        length: 32,
        isWithLetters: true,
        isWithNumbers: true,
        isWithSpecial: true,
        isWithUppercase: true,
      );
      var salt = await CryptoUtils.generateSaltForPwHash();
      print(salt);
      secretKey = await CryptoUtils.encryptMessage(secretKey, passphrase, salt);
      return SoftSigner(
        secretKey: secretKey,
        validity: validity,
        passphrase: passphrase,
        salt: salt,
      );
    } else {
      return SoftSigner(secretKey: secretKey);
    }
  }

  Future<Uint8List> getKey() async {
    if (!_unlocked) {
      var k = await CryptoUtils.decryptMessage(_secretKey, _passphrase, _salt);
      if (_lockTimout == 0) {
        return k;
      }
      _key = k;
      _unlocked = true;
      if (_lockTimout > 0) {
        Future.delayed(Duration(milliseconds: _lockTimout * 1000), () {
          _key = Uint8List(0);
          _unlocked = false;
        });
      }
      return _key;
    }
    return _key;
  }

  Future<Uint8List> signOperation(Uint8List uint8list) async {
    return await CryptoUtils.signDetached(
        TezosMessageUtils.simpleHash(uint8list, 32),
        Uint8List.fromList(await getKey()));
  }

  SignerCurve getSignerCurve() {
    return SignerCurve.ED25519;
  }
}
