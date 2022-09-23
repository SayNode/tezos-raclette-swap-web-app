import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tezos_swap_frontend/pages/widgets/token_select_button.dart';
import 'package:tezos_swap_frontend/repositories/contract_repo.dart';
import 'package:tezos_swap_frontend/services/token_provider.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';
import '../../models/contract_model.dart';
import '../../models/token.dart';
import '../../utils/globals.dart';
import '../../utils/value_listenable2.dart';

class Swap extends StatefulWidget {
  final WalletProvider provider;
  const Swap({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  State<Swap> createState() => _SwapState();
}

class _SwapState extends State<Swap> {
  TextEditingController upperController = TextEditingController();
  TextEditingController lowerController = TextEditingController();
  bool tokenPairSelected = false;
  final tokenProvider1 = TokenProvider();
  final tokenProvider2 = TokenProvider();
  //mock ratio
  double tokenRatio = 0.5;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Container(
            width: 600,
            height: 500,
            margin: EdgeInsets.symmetric(vertical: 200),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: ThemeRaclette.black,
                borderRadius: BorderRadius.circular(12)),
            child: Form(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Swap',
                        style: TextStyle(fontSize: 20),
                      ),
                      IconButton(
                          onPressed: () {
                            debugPrint('pressing settings');
                          },
                          icon: const Icon(
                            Icons.settings,
                            color: ThemeRaclette.white,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ValueListenableBuilder2(
                      first: tokenProvider1,
                      second: tokenProvider2,
                      builder: ((context, a, b, child) => SwapEntry(
                            controller: upperController,
                            function: (value) {
                              lowerController.text =
                                  (value * tokenRatio).toString();
                            },
                            enabled: (tokenProvider1.token != null &&
                                tokenProvider2.token != null),
                            tokenProvider: tokenProvider1,
                          ))),
                  const SizedBox(
                    height: 15,
                  ),
                  ValueListenableBuilder2(
                      first: tokenProvider1,
                      second: tokenProvider2,
                      builder: ((context, a, b, child) => SwapEntry(
                          controller: lowerController,
                          function: (value) {
                            upperController.text =
                                (value / tokenRatio).toString();
                          },
                          enabled: (tokenProvider1.token != null &&
                              tokenProvider2.token != null),
                          tokenProvider: tokenProvider2))),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: upperController,
                          builder: (context, value, child) =>
                              ValueListenableBuilder2(
                                  first: tokenProvider1,
                                  second: tokenProvider2,
                                  builder: ((context, a, b, child) => Obx(() =>
                                      _connectWallet(
                                          walletProvider.address.string)))))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _connectWallet(String address) {
    if (address.isNotEmpty) {
      if (tokenProvider1.token != null &&
          tokenProvider2.token != null &&
          contracts!.any((element) =>
              element.tokenX == tokenProvider1.token!.tokenAddress &&
                  element.tokenY == tokenProvider2.token!.tokenAddress ||
              element.tokenX == tokenProvider2.token!.tokenAddress &&
                  element.tokenY == tokenProvider1.token!.tokenAddress)) {
        if (upperController.text.isNotEmpty &&
            double.parse(upperController.text) != 0) {
          bool yToX = false;
          if (contracts!.any((element) =>
              element.tokenX == tokenProvider2.token!.tokenAddress &&
              element.tokenY == tokenProvider1.token!.tokenAddress)) {
            yToX = true;
          }
          return ElevatedButton(
              style: ThemeRaclette.invertedButtonStyle,
              onPressed: () async {
                Contract contract = contracts!.firstWhere((element) =>
                    element.tokenX == tokenProvider1.token!.tokenAddress &&
                        element.tokenY == tokenProvider2.token!.tokenAddress ||
                    element.tokenX == tokenProvider2.token!.tokenAddress &&
                        element.tokenY == tokenProvider1.token!.tokenAddress);
                await widget.provider.swap(
                    contract,
                    'tz1LPSEaUzD1V6Qu3TAi6iCiktRGF1t2up4Z',
                    double.parse(upperController.text).toInt(),
                    double.parse(lowerController.text).toInt(),
                    yToX: yToX);
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
          await widget.provider.requestPermission();
        },
        child: Text(
          'Connect Wallet',
          style: ThemeRaclette.invertedButtonTextStyle,
        ));
  }
}

class SwapEntry extends StatefulWidget {
  const SwapEntry({
    Key? key,
    required this.controller,
    required this.function,
    required this.enabled,
    required this.tokenProvider,
  }) : super(key: key);
  final Function function;
  final TextEditingController controller;
  final bool enabled;
  final TokenProvider tokenProvider;

  @override
  State<SwapEntry> createState() => _SwapEntryState();
}

class _SwapEntryState extends State<SwapEntry> {
  Token? token;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      height: 100,
      decoration: BoxDecoration(
          color: ThemeRaclette.gray500,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 300,
            height: 30,
            child: TextFormField(
              enabled: widget.enabled,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                FilteringTextInputFormatter.singleLineFormatter
              ],
              onChanged: (value) {
                if (value.isNotEmpty) {
                  widget.function(double.tryParse(value));
                } else {
                  widget.function(0);
                }
              },
              controller: widget.controller,
              decoration: const InputDecoration.collapsed(
                  hintText: '0.0',
                  hintStyle: TextStyle(color: ThemeRaclette.white)),
              style: const TextStyle(fontSize: 30, color: ThemeRaclette.white),
            ),
          ),
          TokenSelectButton(widget.tokenProvider),
        ],
      ),
    );
  }
}
