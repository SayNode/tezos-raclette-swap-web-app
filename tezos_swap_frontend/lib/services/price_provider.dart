import 'dart:convert';
import '../../models/token.dart';
import 'package:http/http.dart' as http;

var headers = {
  'accept': 'application/json',
};

//TODO: get api key for project
String coingeckoAPIKey = 'CG-cNvdmjaCPddJxEfJF8c7Qvgq';

class PriceProvider {
  static Future<Map> getPriceForMultiple(List<Token> tokenList) async {
    List<String> tokenAddressList =
        tokenList.map((e) => e.tokenAddress).toList();

    Map params = {
      'contract_addresses': tokenAddressList.join(','),
      'vs_currencies': 'usd',
      'x_cg_pro_api_key': coingeckoAPIKey
    };

    String query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    var url = Uri.parse(
        'https://api.coingecko.com/api/v3/simple/token_price/tezos?$query');
    var res = await http.get(url, headers: headers);
    if (res.statusCode != 200) {
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    }
    var out = json.decode(res.body);
    if (tokenList.any((element) => element.id == 'tezos')) {
      var tezosPrice = await getPriceOfTezos();
      out['tezos'] = tezosPrice['tezos'];
    }
    return out;
  }

  static Future<Map> getPriceForSingle(Token token) async {
    if (token.id == 'tezos') {
      return await PriceProvider.getPriceOfTezos();
    }
    Map params = {
      'contract_addresses': token.tokenAddress,
      'vs_currencies': 'usd',
      'x_cg_pro_api_key': coingeckoAPIKey
    };

    String query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    var url = Uri.parse(
        'https://api.coingecko.com/api/v3/simple/token_price/tezos?$query');
    var res = await http.get(url, headers: headers);
    if (res.statusCode != 200) {
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    }
    return json.decode(res.body);
  }

  static Future<Map> getPriceOfTezos() async {
    var params = {
      'ids': 'tezos',
      'vs_currencies': 'usd',
    };
    var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    var url = Uri.parse('https://api.coingecko.com/api/v3/simple/price?$query');
    var res = await http.get(url, headers: headers);
    if (res.statusCode != 200) {
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    }
    return json.decode(res.body);
  }
}
