import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_swap_frontend/models/token.dart';
import 'package:tezos_swap_frontend/services/token_service.dart';
import 'package:tezos_swap_frontend/services/price_provider.dart';

void main() {
  test('test getPriceForMultiple', () async {
    Token token1 = Token.fromJson({
      "id": "KT1Xobej4mc6XgEjDoJoHtTKgbD1ELMvcQuL",
      "name": "Youves YOU Governance",
      "symbol": "YOU",
      "icon": "image/Tezos_Logo_2022.png",
      "iconBlack": "image/Tezos_Logo_2022_black.png",
      "tokenAddress": "KT1Xobej4mc6XgEjDoJoHtTKgbD1ELMvcQuL"
    });
    Token token2 = Token.fromJson({
      "id": "KT19y6R8x53uDKiM46ahgguS6Tjqhdj2rSzZ",
      "name": "Instaraise ",
      "symbol": "INSTA",
      "icon": "image/Tezos_Logo_2022.png",
      "iconBlack": "image/Tezos_Logo_2022_black.png",
      "tokenAddress": "KT19y6R8x53uDKiM46ahgguS6Tjqhdj2rSzZ"
    });

    List<Token> tokenList = [token1, token2];

    Map res = await PriceProvider.getPriceForMultiple(tokenList);
    for (var token in tokenList) {
      expect(res.containsKey(token.id), true);
    }
  });

  test('test getPriceForSingle', () async {
    Token token = Token.fromJson({
      "id": "KT1Xobej4mc6XgEjDoJoHtTKgbD1ELMvcQuL",
      "name": "Youves YOU Governance",
      "symbol": "YOU",
      "icon": "image/Tezos_Logo_2022.png",
      "iconBlack": "image/Tezos_Logo_2022_black.png",
      "tokenAddress": "KT1Xobej4mc6XgEjDoJoHtTKgbD1ELMvcQuL"
    });

    Map res = await PriceProvider.getPriceForSingle(token);

    expect(res.containsKey(token.id), true);
  });

  test('test getPriceForSingle is tezos', () async {
    Token token = Token.fromJson({
      "id": "tezos",
      "name": "Tezos",
      "symbol": "XTZ",
      "icon": "image/Tezos_Logo_2022.png",
      "iconBlack": "image/Tezos_Logo_2022_black.png",
      "tokenAddress": ""
    });

    Map res = await PriceProvider.getPriceForSingle(token);

    expect(res.containsKey(token.id), true);
  });

  test('test getPriceForMultiple contains tezos', () async {
    Token token1 = Token.fromJson({
      "id": "tezos",
      "name": "Tezos",
      "symbol": "XTZ",
      "icon": "image/Tezos_Logo_2022.png",
      "iconBlack": "image/Tezos_Logo_2022_black.png",
      "tokenAddress": ""
    });
    Token token2 = Token.fromJson({
      "id": "KT19y6R8x53uDKiM46ahgguS6Tjqhdj2rSzZ",
      "name": "Instaraise ",
      "symbol": "INSTA",
      "icon": "image/Tezos_Logo_2022.png",
      "iconBlack": "image/Tezos_Logo_2022_black.png",
      "tokenAddress": "KT19y6R8x53uDKiM46ahgguS6Tjqhdj2rSzZ"
    });

    List<Token> tokenList = [token1, token2];

    Map res = await PriceProvider.getPriceForMultiple(tokenList);
    for (var token in tokenList) {
      expect(res.containsKey(token.id), true);
    }
  });
}
