import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_swap_frontend/models/token.dart';
import 'package:tezos_swap_frontend/services/balance_provider.dart';

void main() {
  test('test', () async {
    Token token1 = Token.fromJson({
      "id": "KT1S5iPRQ612wcNm6mXDqDhTNegGFcvTV7vM",
      "name": "Youves YOU Governance",
      "symbol": "YOU",
      "icon": "image/eth_logo.png",
      "iconBlack": "image/eth_logo_black.png",
      "tokenAddress": "KT1Xobej4mc6XgEjDoJoHtTKgbD1ELMvcQuL"
    });
    Token token2 = Token.fromJson({
      "id": "KT19y6R8x53uDKiM46ahgguS6Tjqhdj2rSzZ",
      "name": "Instaraise ",
      "symbol": "INSTA",
      "icon": "image/eth_logo.png",
      "iconBlack": "image/eth_logo_black.png",
      "tokenAddress": "KT19y6R8x53uDKiM46ahgguS6Tjqhdj2rSzZ"
    });

    List<Token> tokenList = [token1, token2];
  });
  test('test balance of token', () async {
    Token token = Token.fromJson({
      "id": "KT1U6EHmNxJTkvaWJ4ThczG4FSDaHC21ssvi",
      "name": "",
      "symbol": "",
      "icon": "",
      "iconBlack": "",
      "tokenAddress": "KT1U6EHmNxJTkvaWJ4ThczG4FSDaHC21ssvi"
    });
    var res = await BalanceProvider.getBalance(
        'tz1RKAK88z71SGmipocZqVXQrtWJxo7dfH7Z', [token]);
    print('Response: $res');
  });
}
