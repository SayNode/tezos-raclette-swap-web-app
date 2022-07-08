import 'dart:typed_data';
import 'package:sodium_web/sodium_web.dart' as s;
import 'package:tezos_swap_frontend/services/tezster/sodium_utils.dart';

class SodiumUtilsWeb extends SodiumUtils {
  @override
  Uint8List rand(length) {
    return s.Sodium.randombytesBuf(length);
  }

  @override
  Uint8List salt() {
    return Uint8List.fromList(rand(s.Sodium.cryptoPwhashSaltbytes).toList());
  }

  @override
  Uint8List pwhash(String passphrase, Uint8List salt) {
    return s.Sodium.cryptoPwhash(
        s.Sodium.cryptoBoxSeedbytes,
        Uint8List.fromList(passphrase.codeUnits),
        salt,
        4,
        33554432,
        s.Sodium.cryptoPwhashAlgArgon2i13 as int);
  }

  @override
  Uint8List nonce() {
    return rand(s.Sodium.cryptoBoxNoncebytes);
  }

  @override
  Uint8List close(Uint8List message, Uint8List nonce, Uint8List keyBytes) {
    return s.Sodium.cryptoSecretboxEasy(message, nonce, keyBytes);
  }

  @override
  Uint8List open(Uint8List nonceAndCiphertext, Uint8List key) {
    var nonce = nonceAndCiphertext.sublist(
        0, s.Sodium.cryptoSecretboxNoncebytes as int);
    var ciphertext =
        nonceAndCiphertext.sublist(s.Sodium.cryptoSecretboxNoncebytes as int);

    return s.Sodium.cryptoSecretboxOpenEasy(ciphertext, nonce, key);
  }

  @override
  Uint8List sign(Uint8List simpleHash, Uint8List key) {
    return s.Sodium.cryptoSignDetached(simpleHash, key);
  }

  @override
  KeyPair publicKey(Uint8List sk) {
    var seed = s.Sodium.cryptoSignEd25519SkToSeed(sk);
    var temp = s.Sodium.cryptoSignSeedKeypair(seed);
    return KeyPair(sk: temp.sk, pk: temp.pk);
  }

  @override
  KeyPair cryptoSignSeedKeypair(Uint8List seed) {
    var temp = s.Sodium.cryptoSignSeedKeypair(seed);
    return KeyPair(sk: temp.sk, pk: temp.pk);
  }

  @override
  Uint8List cryptoSignDetached(Uint8List a, Uint8List b) {
    return s.Sodium.cryptoSignDetached(a, b);
  }
}

SodiumUtils getSodium() => SodiumUtilsWeb();