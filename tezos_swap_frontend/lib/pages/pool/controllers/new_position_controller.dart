// ignore_for_file: unnecessary_cast

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/core.dart';

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

  updateTokenCalc() async {
    try {
      if (changedX == 1) {
        var amount = await calcSecondTokenAmount(
            double.parse(lowerController.text),
            18,
            min.value,
            max.value,
            testContract,
            isY: true);

        upperController.text = amount.toString();
      } else if (changedX == 0) {
        var amount = await calcSecondTokenAmount(
            double.parse(upperController.text),
            18,
            min.value,
            max.value,
            testContract,
            isY: true);

        lowerController.text = amount.toString();
        
      }
    } catch (e) {}
  }

  calcAmount() async {
    if (tokenX.value != null &&
        tokenY.value != null &&
        double.tryParse(upperController.text) != null) {
      secondTokenAmount.value = await calcSecondTokenAmount(
          double.parse(upperController.text),
          18,
          min.value,
          max.value,
          testContract);
    }
  }
}
