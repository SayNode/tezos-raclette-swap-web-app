import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

//import 'package:flutter_sodium/flutter_sodium.dart';
import 'package:sodium_libs/sodium_libs.dart';

class SodiumUtils {
  static Uint8List rand(length) {
    final Random _random = Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return Uint8List.fromList(values);
  }

  static Future<Uint8List> salt() async {
    final sodium = await SodiumInit.init();
    print(sodium);

    return Uint8List.fromList(rand(sodium.crypto.pwhash.saltBytes).toList());
  }

  static Future<Uint8List> pwhash(String passphrase, Uint8List salt) async {
    final sodium = await SodiumInit.init();

    return sodium.crypto.pwhash
        .call(
            outLen: sodium.crypto.box.seedBytes,
            password: Int8List.fromList(passphrase.codeUnits),
            salt: salt,
            opsLimit: 4,
            memLimit: 33554432,
            alg: CryptoPwhashAlgorithm.argon2i13)
        .extractBytes();
  }

  static Future<Uint8List> nonce() async {
    final sodium = await SodiumInit.init();
    return rand(sodium.crypto.box.nonceBytes);
  }

  static Future<Uint8List> close(
      Uint8List message, Uint8List nonce, Uint8List keyBytes) async {
    final sodium = await SodiumInit.init();

    return sodium.crypto.secretBox.easy(
        message: message,
        nonce: nonce,
        key: SecureKey.fromList(sodium, keyBytes));
  }

  static Future<Uint8List> open(
      Uint8List nonceAndCiphertext, Uint8List key) async {
    final sodium = await SodiumInit.init();

    var nonce =
        nonceAndCiphertext.sublist(0, sodium.crypto.secretBox.nonceBytes);
    var cipherText =
        nonceAndCiphertext.sublist(sodium.crypto.secretBox.nonceBytes);

    return sodium.crypto.secretBox.openEasy(
        cipherText: cipherText,
        nonce: nonce,
        key: SecureKey.fromList(sodium, key));
  }

  static Future<Uint8List> sign(Uint8List simpleHash, Uint8List key) async {
    final sodium = await SodiumInit.init();

    return sodium.crypto.sign.detached(
        message: simpleHash, secretKey: SecureKey.fromList(sodium, key));
  }

  static Future<KeyPair> publicKey(Uint8List sk) async {
    final sodium = await SodiumInit.init();

    var seed = sodium.crypto.sign.skToSeed(SecureKey.fromList(sodium, sk));

    return sodium.crypto.sign.seedKeyPair(seed);
  }
}
