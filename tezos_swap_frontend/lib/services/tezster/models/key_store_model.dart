
class KeyStoreModel {
  String publicKey;
  String secretKey;
  String publicKeyHash;
  var seed;
  String? email;
  String? password;
  String? secret;

  KeyStoreModel({
    required this.publicKey,
    required this.secretKey,
    required this.publicKeyHash,
    this.seed,
    this.secret,
    this.email,
    this.password,
  });
}
