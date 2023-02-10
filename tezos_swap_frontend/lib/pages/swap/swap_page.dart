import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tezos_swap_frontend/pages/swap/controllers/swap_page_controller.dart';
import 'package:tezos_swap_frontend/pages/widgets/token_select_button.dart';
import 'package:tezos_swap_frontend/services/contract_service.dart';
import 'package:tezos_swap_frontend/services/token_provider.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';
import 'package:tezos_swap_frontend/utils/utils.dart';
import '../../models/token.dart';
import '../../utils/globals.dart';
import '../../utils/value_listenable2.dart';

class SwapPage extends GetView<SwapController> {
  SwapPage({
    Key? key,
  }) : super(key: key);

  

  //mock ratio
  @override
  Widget build(BuildContext context) {
    Get.put(SwapController());
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
                      first: controller.tokenProvider1,
                      second: controller.tokenProvider2,
                      builder: ((context, a, b, child) => SwapEntry(
                            controller: controller.upperController,
                            function: (value) async {
                              bool yToX = false;
                              if (controller.contracts.any((element) =>
                                  element.tokenX ==
                                      controller
                                          .tokenProvider2.token!.tokenAddress &&
                                  element.tokenY ==
                                      controller.tokenProvider1.token!
                                          .tokenAddress)) {
                                yToX = true;
                              }
                              var a = await calcSecondTokenAmountSwap(
                                  double.parse(controller.upperController.text),
                                  18,
                                  testContract,
                                  yToX);

                              controller.lowerController.text = a.toString();
                            },
                            enabled: controller.checkValidTokenPair(),
                            tokenProvider: controller.tokenProvider1,
                          ))),
                  const SizedBox(
                    height: 15,
                  ),
                  ValueListenableBuilder2(
                      first: controller.tokenProvider1,
                      second: controller.tokenProvider2,
                      builder: ((context, a, b, child) => SwapEntry(
                          controller: controller.lowerController,
                          function: (value) async {},
                          enabled: false,
                          tokenProvider: controller.tokenProvider2))),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: controller.upperController,
                          builder: (context, value, child) =>
                              ValueListenableBuilder2(
                                  first: controller.tokenProvider1,
                                  second: controller.tokenProvider2,
                                  builder: ((context, a, b, child) => Obx(() =>
                                      controller.connectWallet(controller
                                          .walletService.address.string)))))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
