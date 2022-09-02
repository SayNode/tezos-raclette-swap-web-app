import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/models/chart_datapoint.dart';
import 'package:tezos_swap_frontend/pages/widgets/token_select_button.dart';
import 'package:tezos_swap_frontend/services/token_provider.dart';
import '../../theme/ThemeRaclette.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as chart;

class Pool extends StatefulWidget {
  const Pool({
    Key? key,
  }) : super(key: key);

  @override
  State<Pool> createState() => _PoolState();
}

class _PoolState extends State<Pool> {
  TextEditingController upperController = TextEditingController();
  TokenProvider token1 = TokenProvider();
  TokenProvider token2 = TokenProvider();
  SfRangeValues initSliderValue = const SfRangeValues(5, 15);
  double min = 0;
  double max = 20;

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
      child: Container(
        height: 700,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: ThemeRaclette.black,
            borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          width: 1000,
          child: Column(
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(18))),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('fee tier'),
                              ),
                              const Expanded(child: SizedBox()),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      print('clicked edit');
                                    },
                                    child: const Text('Edit')),
                              )
                            ],
                          ),
                        ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 200,
                                height: 30,
                                child: TextFormField(
                                  controller: upperController,
                                  decoration: const InputDecoration.collapsed(
                                      hintText: '0.0',
                                      hintStyle: TextStyle(
                                          color: ThemeRaclette.white)),
                                  style: const TextStyle(
                                      fontSize: 30, color: ThemeRaclette.white),
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
                                            style:
                                                TextStyle(color: Colors.black),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 200,
                                height: 30,
                                child: TextFormField(
                                  controller: upperController,
                                  decoration: const InputDecoration.collapsed(
                                      hintText: '0.0',
                                      hintStyle: TextStyle(
                                          color: ThemeRaclette.white)),
                                  style: const TextStyle(
                                      fontSize: 30, color: ThemeRaclette.white),
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
                                            style:
                                                TextStyle(color: Colors.black),
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
                        style:  TextStyle(fontSize: 20),
                      ),
                      const Text(
                        'Current Price:',
                      ),
                      SizedBox(
                        width: 300,
                        child: SfRangeSelector(
                          min: min,
                          max: max,
                          onChangeStart: ((value) => print(value)),
                          initialValues: initSliderValue,
                          labelPlacement: LabelPlacement.onTicks,
                          interval: 5,
                          showTicks: true,
                          showLabels: true,
                          child: SizedBox(
                            height: 200,
                            child: chart.SfCartesianChart(
                              margin: const EdgeInsets.all(0),
                              primaryXAxis: chart.NumericAxis(
                                minimum: min,
                                maximum: max,
                                isVisible: false,
                              ),
                              primaryYAxis: chart.NumericAxis(
                                  isVisible: false, maximum: 4),
                              series: <
                                  chart.SplineAreaSeries<ChartDatapoint,
                                      double>>[
                                chart.SplineAreaSeries<ChartDatapoint, double>(
                                    dataSource: _chartChartDatapoint,
                                    xValueMapper:
                                        (ChartDatapoint sales, int index) =>
                                            sales.x,
                                    yValueMapper:
                                        (ChartDatapoint sales, int index) =>
                                            sales.y)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
