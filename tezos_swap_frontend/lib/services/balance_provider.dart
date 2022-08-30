import 'package:http/http.dart' as http;

Future<String> getBalance(String address, String rpc) async {
var response = await http.get(Uri.parse('$rpc/chains/main/blocks/head/context/contracts/$address/balance'));
    return response.body;
  }