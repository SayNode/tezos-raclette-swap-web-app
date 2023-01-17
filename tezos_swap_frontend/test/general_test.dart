import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_swap_frontend/models/token.dart';
import 'package:tezos_swap_frontend/services/balance_provider.dart';
import 'package:tezos_swap_frontend/utils/utils.dart';

void main() {
  test('small to full test', () {
    var a = etherToWei(0.1234567, 5);
    print(a);
  });
}
