import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_swap_frontend/utils/utils.dart';

void main() {
  test('liq2', () async {
    var currentTick =
        await getCurrentTick('KT1TZTkhnZFPL7cdNaif9B3r5oQswM1pnCXB');
    var xLiq = await getLiquidity2(5.51, 0, 1, 20, currentTick, true);
    print('done');
    print(xLiq);
  });

  test('calc tk2', () async {
    var tk2 = await calcSecondTokenAmount(
        5.454435677941918, 18, 1, 20, 'KT1TZTkhnZFPL7cdNaif9B3r5oQswM1pnCXB',
        isY: true);
    print(tk2);
  });
}
