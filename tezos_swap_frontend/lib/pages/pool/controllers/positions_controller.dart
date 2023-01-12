import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/globals.dart';
import '../../../utils/utils.dart';

class PositionsController extends GetxController {
  RxList positions = [].obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    positions.value =
        await positionsOfAddress(walletProvider.address.string, testContract);
    positions.refresh();
    super.onInit();
  }
}
