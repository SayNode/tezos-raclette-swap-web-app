import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezos_swap_frontend/models/chart_datapoint.dart';
import 'package:tezos_swap_frontend/pages/pool/widgets/fee_tier_card.dart';
import 'package:tezos_swap_frontend/pages/pool/widgets/price_card.dart';
import 'package:tezos_swap_frontend/pages/widgets/token_select_button.dart';
import 'package:tezos_swap_frontend/services/token_provider.dart';
import 'package:tezos_swap_frontend/utils/utils.dart';
import 'package:tezos_swap_frontend/utils/value_listenable2.dart';
import '../../services/wallet_connection.dart';
import '../../theme/ThemeRaclette.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as chart;
import 'package:syncfusion_flutter_core/core.dart';

class Pool extends StatefulWidget {
  final WalletProvider provider;
  const Pool({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  State<Pool> createState() => _PoolState();
}

class _PoolState extends State<Pool> {
  final List<double> feeTier = [0.01, 0.05, 0.3, 1];
  double tokenFactor = 4.2;
  bool edit = false;
  RxInt selected = 2.obs;
  final upperController = TextEditingController();
  final lowerController = TextEditingController();
  TokenProvider token1 = TokenProvider();
  TokenProvider token2 = TokenProvider();
  RxDouble min = 0.0.obs;
  RxDouble max = 20.0.obs;
  RangeController rangeController = RangeController(start: 5, end: 11);
//mock ratio
  double tokenRatio = 2.4;
  //example ChartDatapoint
  final List<ChartDatapoint> _chartChartDatapoint = <ChartDatapoint>[
    ChartDatapoint(x: 11, y: 3.4),
    ChartDatapoint(x: 12, y: 2.8),
    ChartDatapoint(x: 13, y: 1.6),
    ChartDatapoint(x: 14, y: 2.3),
    ChartDatapoint(x: 15, y: 2.5),
    ChartDatapoint(x: 16, y: 2.9),
    ChartDatapoint(x: 17, y: 3.8),
    ChartDatapoint(x: 18, y: 2.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
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
                                      child: TokenSelectButton(token1),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(.0),
                                      child: TokenSelectButton(token2),
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
                                  border: Border.all(color: Colors.green),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(18))),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Obx((() => Text(
                                        '${feeTier[selected.value]}% fee tier'))),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            edit = !edit;
                                          });
                                        },
                                        child: edit
                                            ? const Text('Hide')
                                            : const Text('Edit')),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Obx(
                                (() => _feeSelection(edit, selected.value))),
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
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    height: 30,
                                    child: ValueListenableBuilder2(
                                      first: token1,
                                      second: token2,
                                      builder: (context, a, b, child) {
                                        bool enabled = false;
                                        if (token1.token != null &&
                                            token2.token != null) {
                                          enabled = true;
                                        }
                                        return TextFormField(
                                          enabled: enabled,
                                          onChanged: (value) {
                                            double price = 0;
                                            try {
                                              price = double.parse(
                                                  upperController.text);
                                            } catch (e) {}
                                            lowerController.text =
                                                (price / tokenFactor)
                                                    .toString();
                                          },
                                          controller: upperController,
                                          decoration:
                                              const InputDecoration.collapsed(
                                                  hintText: '0.0',
                                                  hintStyle: TextStyle(
                                                      color:
                                                          ThemeRaclette.white)),
                                          style: const TextStyle(
                                              fontSize: 30,
                                              color: ThemeRaclette.white),
                                        );
                                      },
                                    ),
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: token1,
                                    builder: (context, value, child) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        (token1.token != null)
                                            ? Image.asset(
                                                token1.token!.icon,
                                                width: 25,
                                              )
                                            : const SizedBox(),
                                        (token1.token != null)
                                            ? Text(
                                                token1.token!.symbol,
                                                style: const TextStyle(
                                                    color: ThemeRaclette.black),
                                              )
                                            : const Text(
                                                "Select Token",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                      ],
                                    ),
                                  ),
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
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    height: 30,
                                    child: ValueListenableBuilder2(
                                      first: token1,
                                      second: token2,
                                      builder: (context, a, b, child) {
                                        bool enabled = false;
                                        if (token1.token != null &&
                                            token2.token != null) {
                                          enabled = true;
                                        }
                                        return TextFormField(
                                          enabled: enabled,
                                          controller: lowerController,
                                          onChanged: (value) {
                                            double price = 0;
                                            try {
                                              price = double.parse(
                                                  lowerController.text);
                                            } catch (e) {}
                                            upperController.text =
                                                (price / tokenFactor)
                                                    .toString();
                                          },
                                          decoration:
                                              const InputDecoration.collapsed(
                                                  hintText: '0.0',
                                                  hintStyle: TextStyle(
                                                      color:
                                                          ThemeRaclette.white)),
                                          style: const TextStyle(
                                              fontSize: 30,
                                              color: ThemeRaclette.white),
                                        );
                                      },
                                    ),
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: token2,
                                    builder: (context, value, child) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        (token2.token != null)
                                            ? Image.asset(
                                                token2.token!.icon,
                                                width: 25,
                                              )
                                            : const SizedBox(),
                                        (token2.token != null)
                                            ? Text(
                                                token2.token!.symbol,
                                                style: const TextStyle(
                                                    color: ThemeRaclette.black),
                                              )
                                            : const Text(
                                                "Select Token",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
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
                          ValueListenableBuilder2(
                            first: token1,
                            second: token2,
                            builder: (context, a, b, child) {
                              if (token1.token != null &&
                                  token2.token != null) {
                                return SizedBox(
                                  width: 300,
                                  child: Obx(
                                    (() {
                                      rangeController.start = min.value;
                                      rangeController.end = max.value;
                                      return SfRangeSelector(
                                        controller: rangeController,
                                        min: 0,
                                        max: 25,
                                        onChangeEnd: ((value) {
                                          min.value =
                                              roundDouble(value.start, 4);
                                          max.value = roundDouble(value.end, 4);
                                        }),
                                        labelPlacement: LabelPlacement.onTicks,
                                        interval: 5,
                                        showTicks: true,
                                        showLabels: true,
                                        child: SizedBox(
                                          height: 200,
                                          child: chart.SfCartesianChart(
                                            margin: const EdgeInsets.all(0),
                                            primaryXAxis: chart.NumericAxis(
                                              minimum: 0,
                                              maximum: 25,
                                              isVisible: false,
                                            ),
                                            primaryYAxis: chart.NumericAxis(
                                                isVisible: false, maximum: 4),
                                            series: <
                                                chart.SplineAreaSeries<
                                                    ChartDatapoint, double>>[
                                              chart
                                                  .SplineAreaSeries<
                                                          ChartDatapoint,
                                                          double>(
                                                      dataSource:
                                                          _chartChartDatapoint,
                                                      xValueMapper:
                                                          (ChartDatapoint sales,
                                                                  int index) =>
                                                              sales.x,
                                                      yValueMapper:
                                                          (ChartDatapoint sales,
                                                                  int index) =>
                                                              sales.y)
                                            ],
                                          ),
                                        ),
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
                                  child: PriceCard(
                                      'Min Price', token1, token2, min),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: PriceCard(
                                      'Max Price', token1, token2, max),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 400,
                                height: 60,
                                child: _submitButton(
                                    widget.provider.address.string),
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
    );
  }

  Widget _feeSelection(bool edit, int s) {
    if (edit) {
      return SizedBox(
        width: 400,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FeeTierCard('Best for very stable pairs.', feeTier[0], s == 0, () {
              selected.value = 0;
            }),
            FeeTierCard('Best for stable pairs.', feeTier[1], s == 1, () {
              selected.value = 1;
            }),
            FeeTierCard('Best for most pairs', feeTier[2], s == 2, () {
              selected.value = 2;
            }),
            FeeTierCard('Best for exotic pairs.', feeTier[3], s == 3, () {
              selected.value = 3;
            }),
          ],
        ),
      );
    }

    return const SizedBox();
  }

  _submitButton(String address) {
    if (address.isNotEmpty) {
      return ElevatedButton(
          style: ThemeRaclette.invertedButtonStyle,
          onPressed: () async {
            print(feeTier[selected.value]);
            print(token1.token!.name);
            print(token2.token!.name);
            print(min.value);
            print(max.value);
            print(upperController.text);
            print(lowerController.text);
          },
          child: Text(
            'Submit',
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
