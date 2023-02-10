 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../services/contract_service.dart';
import '../../../services/token_provider.dart';
import '../../../services/wallet_connection.dart';
import '../../../theme/ThemeRaclette.dart';
import '../../../utils/globals.dart';

class SwapController extends GetxController {
    var walletService = Get.put(WalletService());

  TextEditingController upperController = TextEditingController();

  TextEditingController lowerController = TextEditingController();

  bool tokenPairSelected = false;

  final tokenProvider1 = TokenProvider();

  final tokenProvider2 = TokenProvider();

  var contracts = Get.put(ContractService()).contracts;

    connectWallet(String address) {
    if (address.isNotEmpty) {
      if (tokenProvider1.token != null &&
          tokenProvider2.token != null &&
          contracts.any((element) =>
              element.tokenX == tokenProvider1.token!.tokenAddress &&
                  element.tokenY == tokenProvider2.token!.tokenAddress ||
              element.tokenX == tokenProvider2.token!.tokenAddress &&
                  element.tokenY == tokenProvider1.token!.tokenAddress)) {
        if (upperController.text.isNotEmpty &&
            double.parse(upperController.text) != 0) {
          bool yToX = false;
          if (contracts.any((element) =>
              element.tokenX == tokenProvider2.token!.tokenAddress &&
              element.tokenY == tokenProvider1.token!.tokenAddress)) {
            yToX = true;
          }
          return ElevatedButton(
              style: ThemeRaclette.invertedButtonStyle,
              onPressed: () async {
                // Contract contract = contracts!.firstWhere((element) =>
                //     element.tokenX == tokenProvider1.token!.tokenAddress &&
                //         element.tokenY == tokenProvider2.token!.tokenAddress ||
                //     element.tokenX == tokenProvider2.token!.tokenAddress &&
                //         element.tokenY == tokenProvider1.token!.tokenAddress);
                await walletService.swap(
                    testContract,
                    walletService.address.string,
                    double.parse(upperController.text),
                    double.parse(lowerController.text),
                    yToX: yToX,
                    tokenProvider1.token!.tokenAddress,
                    tokenProvider2.token!.tokenAddress);
              },
              child: Text(
                'Swap',
                style: ThemeRaclette.invertedButtonTextStyle,
              ));
        }
        return ElevatedButton(
            style: ThemeRaclette.invertedButtonStyle,
            onPressed: null,
            child: Text(
              'Enter Amount',
              style: ThemeRaclette.invertedButtonTextStyle,
            ));
      }
      return ElevatedButton(
          style: ThemeRaclette.invertedButtonStyle,
          onPressed: null,
          child: Text(
            'Invalid Pair',
            style: ThemeRaclette.invertedButtonTextStyle,
          ));
    }
    return ElevatedButton(
        style: ThemeRaclette.invertedButtonStyle,
        onPressed: () async {
          await walletService.requestPermission();
        },
        child: Text(
          'Connect Wallet',
          style: ThemeRaclette.invertedButtonTextStyle,
        ));
  }

    checkValidTokenPair() {
    lowerController.text = '';
    upperController.text = '';
    if (tokenProvider1.token != null &&
        tokenProvider2.token != null &&
        tokenProvider2.token!.tokenAddress != tokenProvider1.token!.tokenAddress) {
      var contract = Get.put(ContractService()).contracts[0];
      if (tokenProvider1.token!.tokenAddress == contract.tokenX &&
          tokenProvider2.token!.tokenAddress == contract.tokenY) {
        return true;
      } else if (tokenProvider1.token!.tokenAddress == contract.tokenY &&
          tokenProvider2.token!.tokenAddress == contract.tokenX) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
 
 
