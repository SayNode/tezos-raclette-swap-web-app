// ignore_for_file: unnecessary_cast

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:tezos_swap_frontend/services/contract_service.dart';

import '../../../models/chart_datapoint.dart';
import '../../../models/token.dart';
import '../../../utils/globals.dart';
import '../../../utils/utils.dart';

class NewPositionController extends GetxController {
  final List<double> feeTier = [0.01, 0.05, 0.3, 1];
  RxInt feeIndex = 2.obs;
  RxBool expandFeeSelection = false.obs;
  final upperController = TextEditingController();
  final lowerController = TextEditingController();
  final minController = TextEditingController();
  final maxController = TextEditingController();
  bool tokenInverted = false;
  Rx<Token?> tokenX = (null as Token?).obs;
  Rx<Token?> tokenY = (null as Token?).obs;
  RxDouble firstTokenAmount = 0.0.obs;
  RxDouble secondTokenAmount = 0.0.obs;
  RxBool yUserInput = false.obs;
  RxList<ChartDatapoint> chart = <ChartDatapoint>[].obs;
  RxInt min = 1.obs;
  RxInt max = 20.obs;
  RxInt chartStart = 1.obs;
  RxInt chartEnd = 30.obs;
  RangeController rangeController = RangeController(start: 5, end: 11);
  int changedX = -1;

  updatedChart() async {
    //chart.value = await compute(buildChartPoints, testContract);
    chart.value = await buildChartPoints(testContract);
    chart.refresh();
  }

  checkValidTokenPair() {
    lowerController.text = '';
    upperController.text = '';
    tokenInverted = false;
    if (tokenX.value != null &&
        tokenY.value != null &&
        tokenY.value!.tokenAddress != tokenX.value!.tokenAddress) {
      var contract = Get.put(ContractService()).contracts[0];
      if (tokenX.value!.tokenAddress == contract.tokenX &&
          tokenY.value!.tokenAddress == contract.tokenY) {
        return true;
      } else if (tokenX.value!.tokenAddress == contract.tokenY &&
          tokenY.value!.tokenAddress == contract.tokenX) {
        tokenInverted = true;
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  updateMin(int newMin) async {
    min.value = newMin;
    await updateTokenCalc();
  }

  checkIfUnderMin() async {
    var currentTick =
        await getCurrentTick('KT1TZTkhnZFPL7cdNaif9B3r5oQswM1pnCXB');
    var currentPrice = pow(1.0001, currentTick);

    return min.value > currentPrice;
  }

  checkIfOverMax() async {
    var currentTick =
        await getCurrentTick('KT1TZTkhnZFPL7cdNaif9B3r5oQswM1pnCXB');
    var currentPrice = pow(1.0001, currentTick);
    return max.value < currentPrice;
  }

  updateMax(int newMax) async {
    max.value = newMax;
    await updateTokenCalc();
  }

  updateTokenCalc() async {
    try {
      if (changedX == 1) {
        double input;
        try {
          input = double.parse(lowerController.text);
        } catch (e) {
          input = 0;
        }
        var amount = await calcSecondTokenAmount(
            input, 18, min.value, max.value, testContract,
            isY: !tokenInverted);

        if (await checkIfUnderMin()) {
          amount = 0;
        }

        upperController.text = amount.toString();
      } else if (changedX == 0) {
        double input;
        try {
          input = double.parse(upperController.text);
        } catch (e) {
          input = 0;
        }
        var amount = await calcSecondTokenAmount(
            input, 18, min.value, max.value, testContract,
            isY: tokenInverted);
        if (await checkIfOverMax()) {
          amount = 0;
        }

        lowerController.text = amount.toString();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // calcAmount() async {
  //   if (tokenX.value != null &&
  //       tokenY.value != null &&
  //       double.tryParse(upperController.text) != null) {
  //     secondTokenAmount.value = await calcSecondTokenAmount(
  //         double.parse(upperController.text),
  //         18,
  //         min.value,
  //         max.value,
  //         testContract);
  //   }
  // }
}
