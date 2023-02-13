import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_swap_frontend/models/token.dart';
import 'package:tezos_swap_frontend/services/balance_provider.dart';
import 'package:tezos_swap_frontend/utils/utils.dart';

void main() {
  test('test', () async {
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
  });

  test('test get positions', () async {
    var a = await positionsOfAddress('tz1fZ3mEJdm8ugFkAx7df4nrs8FXxBiMQoQk',
        'KT1TZTkhnZFPL7cdNaif9B3r5oQswM1pnCXB');
    //var b = await getPositions('KT1TZTkhnZFPL7cdNaif9B3r5oQswM1pnCXB');

    print(a);
  });
  test('test balance of token', () async {
    Token token = Token.fromJson({
      "id": "KT19y6R8x53uDKiM46ahgguS6Tjqhdj2rSzZ",
      "name": "Instaraise ",
      "symbol": "INSTA",
      "icon": "image/Tezos_Logo_2022.png",
      "iconBlack": "image/Tezos_Logo_2022_black.png",
      "tokenAddress": "KT19y6R8x53uDKiM46ahgguS6Tjqhdj2rSzZ"
    });
    var res = await BalanceProvider.getBalance(
        'tz1RKAK88z71SGmipocZqVXQrtWJxo7dfH7Z', [token]);
    print('Response: $res');
  });
}
