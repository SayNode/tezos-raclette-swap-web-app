import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/token.dart';

class BalanceProvider {
  static Future<String> getBalanceTezos(String address, String rpc) async {
    var response = await http.get(
        Uri.parse('$rpc/chains/main/blocks/head/context/contracts/$address'));
    return json.decode(response.body)['balance'];
  }

  static Future<List<Map>> getBalanceTokens(
      String address, List<Token> tokenList) async {
    var headers = {
      'accept': 'application/json',
    };

    List<String> tokenAddressList =
        tokenList.map((e) => e.tokenAddress).toList();

    Map params = {
      "account": address,
      "token.contract": tokenAddressList.join(',')
    };

    String query = params.entries.map((p) => '${p.key}=${p.value}').join('&');
    print(query);

    var url = Uri.parse('https://api.tzkt.io/v1/tokens/balances?$query');
    var res = await http.get(url, headers: headers);
    if (res.statusCode != 200) {
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    }
    var resDecoded = json.decode(res.body);
    List<Map> out = [];
    for (Map element in resDecoded) {
      out.add({
        element['token']['contract']['address']: element['balance'],
        'id': element['token']['tokenId']
      });
    }
    return out;
  }

  static Future<List<Map>> getBalance(String address, List<Token> token) async {
    if (token.length == 1) {
      if (token[0].id == 'tezos') {
        var balance = await BalanceProvider.getBalanceTezos(
            address, 'https://mainnet.api.tez.ie/');
        return [
          {'tezos': balance}
        ];
      } else {
        var balance = await BalanceProvider.getBalanceTokens(address, token);
        return balance;
      }
    } else {
      if (token.any((element) => element.id == 'tezos')) {
        var balance = await BalanceProvider.getBalanceTokens(address, token);
        var tezosBalance = await BalanceProvider.getBalanceTezos(
            address, 'https://mainnet.api.tez.ie/');
        balance.add({'tezos': tezosBalance});
        return balance;
      } else {
        var balance = await BalanceProvider.getBalanceTokens(address, token);
        return balance;
      }
    }
  }
}
