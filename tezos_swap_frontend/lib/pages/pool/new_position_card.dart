import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as chart;
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tezos_swap_frontend/pages/pool/controllers/new_position_controller.dart';
import 'package:tezos_swap_frontend/pages/pool/widgets/fee_tier_card.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import '../../models/chart_datapoint.dart';
import '../../services/new_position_service.dart';
import '../../theme/ThemeRaclette.dart';
import '../../utils/decimal_input_formatter.dart';
import '../../utils/globals.dart';
import '../../utils/utils.dart';
import '../widgets/card_route.dart';
import '../widgets/select_token_card.dart';
import 'widgets/price_card.dart';

class NewPositionCard extends GetView<NewPositionController> {
  const NewPositionCard({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NewPositionController());
    var walletService = Get.put(WalletService());
    return Center(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 200,
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      color: ThemeRaclette.black,
                      borderRadius: BorderRadius.circular(12)),
                  child: SizedBox(
                    width: 1000,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => Get.put(NewPositionService())
                                  .newPosition
                                  .value = false,
                              icon: const Icon(Icons.arrow_back),
                              color: Colors.white,
                            ),
                            const Text(
                              'Add Liquidity',
                              style: TextStyle(fontSize: 24),
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
                        const Divider(
                          color: Colors.white,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'Select Pair',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    width: 400,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Obx(() {
                                              if (controller
                                                  .checkValidTokenPair()) {
                                                controller.updatedChart();
                                              }
                                              return TextButton(
                                                  onPressed: () async {
                                                    var newToken = await Navigator
                                                            .of(context)
                                                        .push(CardDialogRoute(
                                                            builder: (context) {
                                                      return const SelectTokenCard();
                                                    }));

                                                    controller.tokenX.value =
                                                        newToken;
                                                  },
                                                  style:
                                                      ThemeRaclette.buttonStyle,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        (controller.tokenX
                                                                    .value !=
                                                                null)
                                                            ? Image.asset(
                                                                controller
                                                                    .tokenX
                                                                    .value!
                                                                    .icon,
                                                                width: 25,
                                                              )
                                                            : const SizedBox(),
                                                        (controller.tokenX
                                                                    .value !=
                                                                null)
                                                            ? Text(
                                                                controller
                                                                    .tokenX
                                                                    .value!
                                                                    .symbol,
                                                                style: const TextStyle(
                                                                    color: ThemeRaclette
                                                                        .black),
                                                              )
                                                            : const Text(
                                                                "Select Token",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                        const Icon(
                                                          Icons
                                                              .arrow_drop_down_outlined,
                                                          color: ThemeRaclette
                                                              .black,
                                                        )
                                                      ],
                                                    ),
                                                  ));
                                            }),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(.0),
                                            child: Obx(() {
                                              if (controller
                                                  .checkValidTokenPair()) {
                                                controller.updatedChart();
                                              }
                                              return TextButton(
                                                  onPressed: () async {
                                                    var newToken = await Navigator
                                                            .of(context)
                                                        .push(CardDialogRoute(
                                                            builder: (context) {
                                                      return const SelectTokenCard();
                                                    }));

                                                    controller.tokenY.value =
                                                        newToken;
                                                  },
                                                  style:
                                                      ThemeRaclette.buttonStyle,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        (controller.tokenY
                                                                    .value !=
                                                                null)
                                                            ? Image.asset(
                                                                controller
                                                                    .tokenY
                                                                    .value!
                                                                    .icon,
                                                                width: 25,
                                                              )
                                                            : const SizedBox(),
                                                        (controller.tokenY
                                                                    .value !=
                                                                null)
                                                            ? Text(
                                                                controller
                                                                    .tokenY
                                                                    .value!
                                                                    .symbol,
                                                                style: const TextStyle(
                                                                    color: ThemeRaclette
                                                                        .black),
                                                              )
                                                            : const Text(
                                                                "Select Token",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                        const Icon(
                                                          Icons
                                                              .arrow_drop_down_outlined,
                                                          color: ThemeRaclette
                                                              .black,
                                                        )
                                                      ],
                                                    ),
                                                  ));
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    width: 400,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(18))),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Obx((() => Text(
                                              '${controller.feeTier[controller.feeIndex.value]}% fee tier'))),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                controller.expandFeeSelection
                                                        .value =
                                                    !controller
                                                        .expandFeeSelection
                                                        .value;
                                              },
                                              child: controller
                                                      .expandFeeSelection.value
                                                  ? const Text('Hide')
                                                  : const Text('Edit')),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Obx((() => (controller
                                          .expandFeeSelection.value)
                                      ? SizedBox(
                                          width: 400,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FeeTierCard(
                                                  'Best for very stable pairs.',
                                                  controller.feeTier[0],
                                                  controller.feeIndex.value ==
                                                      0, () {
                                                controller.feeIndex.value = 0;
                                              }),
                                              FeeTierCard(
                                                  'Best for stable pairs.',
                                                  controller.feeTier[1],
                                                  controller.feeIndex.value ==
                                                      1, () {
                                                controller.feeIndex.value = 1;
                                              }),
                                              FeeTierCard(
                                                  'Best for most pairs',
                                                  controller.feeTier[2],
                                                  controller.feeIndex.value ==
                                                      2, () {
                                                controller.feeIndex.value = 2;
                                              }),
                                              FeeTierCard(
                                                  'Best for exotic pairs.',
                                                  controller.feeTier[3],
                                                  controller.feeIndex.value ==
                                                      3, () {
                                                controller.feeIndex.value = 3;
                                              }),
                                            ],
                                          ),
                                        )
                                      : const SizedBox())),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text('Deposit Amounts'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(24.0),
                                    width: 400,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: ThemeRaclette.gray500,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          height: 30,
                                          child: Obx(() {
                                            return TextFormField(
                                              inputFormatters: [
                                                DecimalTextInputFormatter(
                                                    decimalRange: 4)
                                              ],
                                              keyboardType: const TextInputType
                                                      .numberWithOptions(
                                                  decimal: true),
                                              enabled: (controller
                                                  .checkValidTokenPair()&&!controller.overMax.value),
                                              onChanged: (value) async {
                                                controller.changedX = 0;
                                                controller.updateTokenCalc();
                                              },
                                              controller:
                                                  controller.upperController,
                                              decoration:  InputDecoration
                                                      .collapsed(
                                                  hintText: (controller.overMax.value)?'Locked':'0.0',
                                                  hintStyle: const TextStyle(
                                                      color:
                                                           ThemeRaclette.white)),
                                              style: const TextStyle(
                                                  fontSize: 30,
                                                  color: ThemeRaclette.white),
                                            );
                                          }),
                                        ),
                                        Obx(() {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              (controller.tokenX.value != null)
                                                  ? Image.asset(
                                                      controller
                                                          .tokenX.value!.icon,
                                                      width: 25,
                                                    )
                                                  : const SizedBox(),
                                              (controller.tokenX.value != null)
                                                  ? Text(
                                                      controller
                                                          .tokenX.value!.symbol,
                                                      style: const TextStyle(
                                                          color: ThemeRaclette
                                                              .black),
                                                    )
                                                  : const Text(
                                                      "Select Token",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                            ],
                                          );
                                        })
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(24.0),
                                    width: 400,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: ThemeRaclette.gray500,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          height: 30,
                                          child: Obx(() {
                                            return TextFormField(
                                              inputFormatters: [
                                                DecimalTextInputFormatter(
                                                    decimalRange: 4)
                                              ],
                                              keyboardType: const TextInputType
                                                      .numberWithOptions(
                                                  decimal: true),
                                              enabled: (controller
                                                  .checkValidTokenPair()&&!controller.underMin.value),
                                              onChanged: (value) async {
                                                controller.changedX = 1;
                                                controller.updateTokenCalc();
                                              },
                                              controller:
                                                  controller.lowerController,
                                              decoration:  InputDecoration
                                                      .collapsed(
                                                  hintText: (controller.underMin.value)?'Locked':'0.0',
                                                  hintStyle: const TextStyle(
                                                      color:
                                                          ThemeRaclette.white)),
                                              style: const TextStyle(
                                                  fontSize: 30,
                                                  color: ThemeRaclette.white),
                                            );
                                          }),
                                        ),
                                        Obx(() {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              (controller.tokenY.value != null)
                                                  ? Image.asset(
                                                      controller
                                                          .tokenY.value!.icon,
                                                      width: 25,
                                                    )
                                                  : const SizedBox(),
                                              (controller.tokenY.value != null)
                                                  ? Text(
                                                      controller
                                                          .tokenY.value!.symbol,
                                                      style: const TextStyle(
                                                          color: ThemeRaclette
                                                              .black),
                                                    )
                                                  : const Text(
                                                      "Select Token",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                            ],
                                          );
                                        })
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select Price Range',
                                  style: TextStyle(fontSize: 20),
                                ),
                                const Text(
                                  'Current Price:',
                                ),
                                Obx(
                                  () {
                                    if (controller.checkValidTokenPair()) {
                                      return SizedBox(
                                        width: 300,
                                        height: 300,
                                        child: Obx(
                                          (() {
                                            controller.rangeController.start =
                                                controller.min.value;
                                            controller.rangeController.end =
                                                controller.max.value;
                                            return SfRangeSelector(
                                              controller:
                                                  controller.rangeController,
                                              min: controller.chartStart.value,
                                              max: controller.chartEnd.value,
                                              onChangeEnd: ((value) {
                                                controller.updateMin(
                                                    value.start.round());
                                                controller.updateMax(
                                                    value.end.round());
                                              }),
                                              labelPlacement:
                                                  LabelPlacement.onTicks,
                                              interval: 5,
                                              showTicks: true,
                                              showLabels: true,
                                              child: SizedBox(
                                                  height: 200,
                                                  width: 300,
                                                  child: chart.SfCartesianChart(
                                                    margin:
                                                        const EdgeInsets.all(0),
                                                    primaryXAxis:
                                                        chart.NumericAxis(
                                                      minimum: 0,
                                                      maximum: 30,
                                                      isVisible: false,
                                                    ),
                                                    primaryYAxis:
                                                        chart.NumericAxis(
                                                            isVisible: false,
                                                            maximum: 50000),
                                                    series: <
                                                        chart.SplineAreaSeries<
                                                            ChartDatapoint,
                                                            double>>[
                                                      chart.SplineAreaSeries<
                                                              ChartDatapoint,
                                                              double>(
                                                          dataSource: controller
                                                              .chart.value,
                                                          xValueMapper:
                                                              (ChartDatapoint
                                                                          sales,
                                                                      int
                                                                          index) =>
                                                                  sales.x,
                                                          yValueMapper:
                                                              (ChartDatapoint
                                                                          sales,
                                                                      int index) =>
                                                                  sales.y)
                                                    ],
                                                  )),
                                            );
                                          }),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox(
                                          width: 300,
                                          height: 300,
                                          child: Center(
                                            child: Text(
                                                'Your position will appear here.'),
                                          ));
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Obx(() => PriceCard(
                                              'Min Price',
                                              controller.tokenX.value,
                                              controller.tokenY.value,
                                              controller.min,
                                              (controller
                                                  .checkValidTokenPair()),
                                              (value) async {
                                                var newMin = int.parse(
                                                    controller
                                                        .minController.text);

                                                if (newMin >=
                                                    controller.max.value) {
                                                  controller.updateMin(
                                                      controller.max.value - 1);

                                                  await controller
                                                      .updateTokenCalc();
                                                } else {
                                                  controller.updateMin(
                                                      int.parse(controller
                                                          .minController.text));
                                                  await controller
                                                      .updateTokenCalc();
                                                }
                                              },
                                              controller:
                                                  controller.minController,
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Obx(() => PriceCard(
                                                'Max Price',
                                                controller.tokenX.value,
                                                controller.tokenY.value,
                                                controller.max,
                                                (controller
                                                    .checkValidTokenPair()),
                                                (value) async {
                                              var newMax = int.parse(controller
                                                  .maxController.text);

                                              if (newMax <=
                                                  controller.min.value) {
                                                controller.max.value =
                                                    controller.updateMax(
                                                        controller.min.value +
                                                            1);

                                                await controller
                                                    .updateTokenCalc();
                                              } else {
                                                controller.max.value =
                                                    controller.updateMax(
                                                        int.parse(controller
                                                            .maxController
                                                            .text));
                                                await controller
                                                    .updateTokenCalc();
                                              }
                                            },
                                                controller:
                                                    controller.maxController)),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 400,
                                      height: 60,
                                      child: Obx(() => (walletService
                                              .address.string.isNotEmpty)
                                          ? ElevatedButton(
                                              style: ThemeRaclette
                                                  .invertedButtonStyle,
                                              onPressed: () async {
                                                //TODO: proper contract selection

                                                // walletProvider.authorizeContract(token1.token!.tokenAddress, testContract);
                                                var tkx;
                                                var tky;

                                                if (controller.tokenInverted) {
                                                  tkx = controller.tokenY.value!
                                                      .tokenAddress;
                                                  tky = controller.tokenX.value!
                                                      .tokenAddress;
                                                } else {
                                                  tkx = controller.tokenX.value!
                                                      .tokenAddress;
                                                  tky = controller.tokenY.value!
                                                      .tokenAddress;
                                                }

                                                walletService.setPosition(
                                                    testContract,
                                                    walletService
                                                        .address.string,
                                                    double.parse(controller
                                                        .upperController.text),
                                                    double.parse(controller
                                                        .lowerController.text),
                                                    controller.min.value,
                                                    controller.max.value,
                                                    tkx,
                                                    tky);
                                              },
                                              child: Text(
                                                'Submit',
                                                style: ThemeRaclette
                                                    .invertedButtonTextStyle,
                                              ))
                                          : ElevatedButton(
                                              style: ThemeRaclette
                                                  .invertedButtonStyle,
                                              onPressed: () async {
                                                await walletService
                                                    .requestPermission();
                                              },
                                              child: Text(
                                                'Connect Wallet',
                                                style: ThemeRaclette
                                                    .invertedButtonTextStyle,
                                              ))),
                                    )),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
