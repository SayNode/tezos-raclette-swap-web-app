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
  Rx<Token?> tokenX = (null as Token?).obs;
  Rx<Token?> tokenY = (null as Token?).obs;

  RxList<ChartDatapoint> chart = <ChartDatapoint>[].obs;
  RxInt min = 1.obs;
  RxInt max = 20.obs;
  RxInt chartStart = 1.obs;
  RxInt chartEnd = 30.obs;
  RangeController rangeController = RangeController(start: 5, end: 11);

  updatedChart() async {
    //chart.value = await compute(buildChartPoints, testContract);
    //chart.value = await buildChartPoints(testContract);
    await Future.delayed(Duration(seconds: 1));
    chart.value = [
      ChartDatapoint(x: 0, y: 1),
      ChartDatapoint(x: 3, y: 10),
      ChartDatapoint(x: 5, y: 11),
      ChartDatapoint(x: 6, y: 12),
      ChartDatapoint(x: 9, y: 13),
      ChartDatapoint(x: 10, y: 20),
      ChartDatapoint(x: 14, y: 11),
      ChartDatapoint(x: 15, y: 50),
      
    ];
    chart.refresh();
  }
}
