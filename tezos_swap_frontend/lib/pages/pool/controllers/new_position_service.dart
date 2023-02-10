import 'dart:math';

import 'package:get/get.dart';

import '../../../utils/utils.dart';

class NewPositionService extends GetxService {
  RxBool newPosition = false.obs;
  RxDouble currentPrice = 0.0.obs;

  init() async {
    var currentTick =
        await getCurrentTick('KT1TZTkhnZFPL7cdNaif9B3r5oQswM1pnCXB');
    currentPrice.value = pow(1.0001, currentTick).toDouble();
    return true;
  }
}
