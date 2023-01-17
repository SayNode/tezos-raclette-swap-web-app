import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';

import '../../../utils/globals.dart';
import '../../../utils/utils.dart';

class PositionsController extends GetxController {
  RxList positions = [].obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    positions.value = await positionsOfAddress(
        Get.put(WalletService()).address.value, testContract);
    positions.refresh();
    super.onInit();
  }
}
