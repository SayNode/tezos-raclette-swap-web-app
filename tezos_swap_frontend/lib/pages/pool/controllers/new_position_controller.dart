// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/token.dart';

class NewPositionController extends GetxController {
  final List<double> feeTier = [0.01, 0.05, 0.3, 1];
  RxInt feeIndex = 2.obs;
  RxBool expandFeeSelection = false.obs;
  final upperController = TextEditingController();
  final lowerController = TextEditingController();
  Rx<Token?> tokenX = (null as Token?).obs;
  Rx<Token?> tokenY = (null as Token?).obs;
}
