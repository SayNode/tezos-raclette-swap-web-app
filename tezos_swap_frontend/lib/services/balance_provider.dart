import 'package:http/http.dart' as http;

Future<String> getBalance(String address, String rpc) async {
    assert(address != null);
    assert(rpc != null);
var response = await http.get(Uri.parse('$rpc/chains/main/blocks/head/context/contracts/$address/balance'));
    return response.toString();
  }