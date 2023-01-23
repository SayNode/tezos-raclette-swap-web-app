// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tezos_swap_frontend/models/chart_datapoint.dart';
// import 'package:tezos_swap_frontend/pages/pool/widgets/fee_tier_card.dart';
// import 'package:tezos_swap_frontend/pages/pool/widgets/price_card.dart';
// import 'package:tezos_swap_frontend/pages/widgets/token_select_button.dart';
// import 'package:tezos_swap_frontend/services/new_position_service.dart';
// import 'package:tezos_swap_frontend/services/token_provider.dart';
// import 'package:tezos_swap_frontend/utils/utils.dart';
// import 'package:tezos_swap_frontend/utils/value_listenable2.dart';
// import '../../services/wallet_connection.dart';
// import '../../theme/ThemeRaclette.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';
// import 'package:syncfusion_flutter_charts/charts.dart' as chart;
// import 'package:syncfusion_flutter_core/core.dart';

// import '../../utils/globals.dart';

// class NewPositionCard extends StatefulWidget {
//   const NewPositionCard({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<NewPositionCard> createState() => _NewPositionCardState();
// }

// class _NewPositionCardState extends State<NewPositionCard> {
//   final List<double> feeTier = [0.01, 0.05, 0.3, 1];
//   double tokenFactor = 1;
//   bool edit = false;
//   RxInt selected = 2.obs;
//   final upperController = TextEditingController();
//   final lowerController = TextEditingController();
//   TokenProvider token1 = TokenProvider();
//   TokenProvider token2 = TokenProvider();
//   RxInt min = 1.obs;
//   RxInt max = 20.obs;
//   RangeController rangeController = RangeController(start: 5, end: 11);
// //mock ratio
//   double tokenRatio = 2;
//   var walletService = Get.put(WalletService());
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ScrollConfiguration(
//         behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 100.0),
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 200,
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                       color: ThemeRaclette.black,
//                       borderRadius: BorderRadius.circular(12)),
//                   child: SizedBox(
//                     width: 1000,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           //mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               onPressed: () => Get.put(NewPositionService())
//                                   .newPosition
//                                   .value = false,
//                               icon: const Icon(Icons.arrow_back),
//                               color: Colors.white,
//                             ),
//                             const Text(
//                               'Add Liquidity',
//                               style: TextStyle(fontSize: 24),
//                             ),
//                             IconButton(
//                                 onPressed: () {
//                                   debugPrint('pressing settings');
//                                 },
//                                 icon: const Icon(
//                                   Icons.settings,
//                                   color: ThemeRaclette.white,
//                                 ))
//                           ],
//                         ),
//                         const Divider(
//                           color: Colors.white,
//                         ),
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Padding(
//                                   padding: EdgeInsets.all(16.0),
//                                   child: Text(
//                                     'Select Pair',
//                                     style: TextStyle(fontSize: 20),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(16.0),
//                                   child: SizedBox(
//                                     width: 400,
//                                     child: Row(
//                                       children: [
//                                         Expanded(
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: TokenSelectButton(token1),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(.0),
//                                             child: TokenSelectButton(token2),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(16.0),
//                                   child: Container(
//                                     width: 400,
//                                     decoration: BoxDecoration(
//                                         border: Border.all(
//                                           color: Colors.white,
//                                           width: 2,
//                                         ),
//                                         borderRadius: const BorderRadius.all(
//                                             Radius.circular(18))),
//                                     child: Row(
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Obx((() => Text(
//                                               '${feeTier[selected.value]}% fee tier'))),
//                                         ),
//                                         const Expanded(child: SizedBox()),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: ElevatedButton(
//                                               onPressed: () {
//                                                 setState(() {
//                                                   edit = !edit;
//                                                 });
//                                               },
//                                               child: edit
//                                                   ? const Text('Hide')
//                                                   : const Text('Edit')),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(16.0),
//                                   child: Obx((() =>
//                                       _feeSelection(edit, selected.value))),
//                                 ),
//                                 const Padding(
//                                   padding: EdgeInsets.all(16.0),
//                                   child: Text('Deposit Amounts'),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(16.0),
//                                   child: Container(
//                                     padding: const EdgeInsets.all(24.0),
//                                     width: 400,
//                                     height: 100,
//                                     decoration: BoxDecoration(
//                                         color: ThemeRaclette.gray500,
//                                         borderRadius:
//                                             BorderRadius.circular(12)),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         SizedBox(
//                                           width: 200,
//                                           height: 30,
//                                           child: ValueListenableBuilder2(
//                                             first: token1,
//                                             second: token2,
//                                             builder: (context, a, b, child) {
//                                               bool enabled = false;
//                                               if (token1.token != null &&
//                                                   token2.token != null) {
//                                                 enabled = true;
//                                               }
//                                               return TextFormField(
//                                                 enabled: enabled,
//                                                 onChanged: (value) async {
//                                                   print('change');
//                                                   // try {
//                                                   var a =
//                                                       await calcSecondTokenAmount(
//                                                           double.parse(
//                                                               upperController
//                                                                   .text),
//                                                           18,
//                                                           min.value,
//                                                           max.value,
//                                                           testContract);
//                                                   print(a);

//                                                   lowerController.text =
//                                                       a.toString();
//                                                   // } catch (e) {
//                                                   //   print('error: ${e.toString()}');
//                                                   // }
//                                                   // lowerController.text =
//                                                   //     (price / tokenFactor)
//                                                   //         .toString();
//                                                 },
//                                                 controller: upperController,
//                                                 decoration:
//                                                     const InputDecoration
//                                                             .collapsed(
//                                                         hintText: '0.0',
//                                                         hintStyle: TextStyle(
//                                                             color: ThemeRaclette
//                                                                 .white)),
//                                                 style: const TextStyle(
//                                                     fontSize: 30,
//                                                     color: ThemeRaclette.white),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                         ValueListenableBuilder(
//                                           valueListenable: token1,
//                                           builder: (context, value, child) =>
//                                               Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               (token1.token != null)
//                                                   ? Image.asset(
//                                                       token1.token!.icon,
//                                                       width: 25,
//                                                     )
//                                                   : const SizedBox(),
//                                               (token1.token != null)
//                                                   ? Text(
//                                                       token1.token!.symbol,
//                                                       style: const TextStyle(
//                                                           color: ThemeRaclette
//                                                               .black),
//                                                     )
//                                                   : const Text(
//                                                       "Select Token",
//                                                       style: TextStyle(
//                                                           color: Colors.white),
//                                                     ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(16.0),
//                                   child: Container(
//                                     padding: const EdgeInsets.all(24.0),
//                                     width: 400,
//                                     height: 100,
//                                     decoration: BoxDecoration(
//                                         color: ThemeRaclette.gray500,
//                                         borderRadius:
//                                             BorderRadius.circular(12)),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         SizedBox(
//                                           width: 200,
//                                           height: 30,
//                                           child: ValueListenableBuilder2(
//                                             first: token1,
//                                             second: token2,
//                                             builder: (context, a, b, child) {
//                                               bool enabled = false;
//                                               if (token1.token != null &&
//                                                   token2.token != null) {
//                                                 enabled = true;
//                                               }
//                                               return TextFormField(
//                                                 enabled: enabled,
//                                                 controller: lowerController,
//                                                 onChanged: (value) async {
//                                                     var a =
//                                                         await calcSecondTokenAmount(
//                                                             double.parse(
//                                                                 upperController
//                                                                     .text),
//                                                             18,
//                                                             min.value,
//                                                             max.value,
//                                                             testContract, isY: true);
//                                                     print(a);

//                                                     upperController.text =
//                                                         a.toString();
//                                                 },
//                                                 decoration:
//                                                     const InputDecoration
//                                                             .collapsed(
//                                                         hintText: '0.0',
//                                                         hintStyle: TextStyle(
//                                                             color: ThemeRaclette
//                                                                 .white)),
//                                                 style: const TextStyle(
//                                                     fontSize: 30,
//                                                     color: ThemeRaclette.white),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                         ValueListenableBuilder(
//                                           valueListenable: token2,
//                                           builder: (context, value, child) =>
//                                               Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               (token2.token != null)
//                                                   ? Image.asset(
//                                                       token2.token!.icon,
//                                                       width: 25,
//                                                     )
//                                                   : const SizedBox(),
//                                               (token2.token != null)
//                                                   ? Text(
//                                                       token2.token!.symbol,
//                                                       style: const TextStyle(
//                                                           color: ThemeRaclette
//                                                               .black),
//                                                     )
//                                                   : const Text(
//                                                       "Select Token",
//                                                       style: TextStyle(
//                                                           color: Colors.white),
//                                                     ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 // Padding(
//                                 //   padding: const EdgeInsets.all(16.0),
//                                 //   child: Container(
//                                 //     padding: const EdgeInsets.all(24.0),
//                                 //     width: 400,
//                                 //     height: 100,
//                                 //     decoration: BoxDecoration(
//                                 //         color: ThemeRaclette.gray500,
//                                 //         borderRadius:
//                                 //             BorderRadius.circular(12)),
//                                 //     child: TextFormField(
//                                 //       controller: liquidityController,
//                                 //       decoration:
//                                 //           const InputDecoration.collapsed(
//                                 //               hintText: 'enter liquidity',
//                                 //               hintStyle: TextStyle(
//                                 //                   color: ThemeRaclette.white)),
//                                 //       style: const TextStyle(
//                                 //           fontSize: 30,
//                                 //           color: ThemeRaclette.white),
//                                 //     ),
//                                 //   ),
//                                 // )
//                               ],
//                             ),
//                             const SizedBox(
//                               width: 20,
//                             ),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Select Price Range',
//                                   style: TextStyle(fontSize: 20),
//                                 ),
//                                 const Text(
//                                   'Current Price:',
//                                 ),
//                                 FutureBuilder<List<ChartDatapoint>>(
//                                   future: buildChartPoints(testContract),
//                                   builder: (
//                                     BuildContext context,
//                                     AsyncSnapshot<List<ChartDatapoint>>
//                                         snapshot,
//                                   ) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return CircularProgressIndicator();
//                                     } else if (snapshot.connectionState ==
//                                         ConnectionState.done) {
//                                       if (snapshot.hasError) {
//                                         return const Text('Error');
//                                       } else if (snapshot.hasData) {
//                                         return ValueListenableBuilder2(
//                                           first: token1,
//                                           second: token2,
//                                           builder: (context, a, b, child) {
//                                             if (token1.token != null &&
//                                                 token2.token != null) {
//                                               return SizedBox(
//                                                 width: 300,
//                                                 child: Obx(
//                                                   (() {
//                                                     rangeController.start =
//                                                         min.value;
//                                                     rangeController.end =
//                                                         max.value;
//                                                     return SfRangeSelector(
//                                                       controller:
//                                                           rangeController,
//                                                       min: 1,
//                                                       max: 50,
//                                                       onChangeEnd: ((value) {
//                                                         min.value =
//                                                             value.start.round();
//                                                         max.value =
//                                                             value.end.round();
//                                                       }),
//                                                       labelPlacement:
//                                                           LabelPlacement
//                                                               .onTicks,
//                                                       interval: 5,
//                                                       showTicks: true,
//                                                       showLabels: true,
//                                                       child: SizedBox(
//                                                           height: 200,
//                                                           child: chart
//                                                               .SfCartesianChart(
//                                                             margin:
//                                                                 const EdgeInsets
//                                                                     .all(0),
//                                                             primaryXAxis: chart
//                                                                 .NumericAxis(
//                                                               minimum: 0,
//                                                               maximum: 50,
//                                                               isVisible: false,
//                                                             ),
//                                                             primaryYAxis: chart
//                                                                 .NumericAxis(
//                                                                     isVisible:
//                                                                         false,
//                                                                     maximum:
//                                                                         20000),
//                                                             series: <
//                                                                 chart.SplineAreaSeries<
//                                                                     ChartDatapoint,
//                                                                     double>>[
//                                                               chart.SplineAreaSeries<
//                                                                       ChartDatapoint,
//                                                                       double>(
//                                                                   dataSource:
//                                                                       snapshot
//                                                                           .data!,
//                                                                   xValueMapper:
//                                                                       (ChartDatapoint sales,
//                                                                               int
//                                                                                   index) =>
//                                                                           sales
//                                                                               .x,
//                                                                   yValueMapper:
//                                                                       (ChartDatapoint sales,
//                                                                               int index) =>
//                                                                           sales.y)
//                                                             ],
//                                                           )),
//                                                     );
//                                                   }),
//                                                 ),
//                                               );
//                                             } else {
//                                               return const SizedBox(
//                                                   width: 300,
//                                                   height: 300,
//                                                   child: Center(
//                                                     child: Text(
//                                                         'Your position will appear here.'),
//                                                   ));
//                                             }
//                                           },
//                                         );
//                                       } else {
//                                         return const Text('Empty data');
//                                       }
//                                     } else {
//                                       return Text(
//                                           'State: ${snapshot.connectionState}');
//                                     }
//                                   },
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: ValueListenableBuilder2(
//                                           first: token1,
//                                           second: token2,
//                                           builder: (context, a, b, child) {
//                                             bool enable = false;
//                                             if (token1.token != null &&
//                                                 token2.token != null) {
//                                               enable = true;
//                                             }
//                                             return PriceCard('Min Price',
//                                                 token1.token, token2.token, min, enable);
//                                           },
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: ValueListenableBuilder2(
//                                           first: token1,
//                                           second: token2,
//                                           builder: (context, a, b, child) {
//                                             bool enable = false;
//                                             if (token1.token != null &&
//                                                 token2.token != null) {
//                                               enable = true;
//                                             }
//                                             return PriceCard('Max Price',
//                                                 token1.token, token2.token, max, enable);
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: SizedBox(
//                                       width: 400,
//                                       height: 60,
//                                       child: Obx(() => (walletService
//                                               .address.string.isNotEmpty)
//                                           ? ElevatedButton(
//                                               style: ThemeRaclette
//                                                   .invertedButtonStyle,
//                                               onPressed: () async {
//                                                 //TODO: proper contract selection

//                                                 // walletProvider.authorizeContract(token1.token!.tokenAddress, testContract);

//                                                 walletService.setPosition(
//                                                     testContract,
//                                                     walletService
//                                                         .address.string,
//                                                     double.parse(
//                                                         upperController.text),
//                                                     double.parse(
//                                                         lowerController.text),
//                                                     min.value,
//                                                     max.value,
//                                                     token1.token!.tokenAddress,
//                                                     token2.token!.tokenAddress);
//                                               },
//                                               child: Text(
//                                                 'Submit',
//                                                 style: ThemeRaclette
//                                                     .invertedButtonTextStyle,
//                                               ))
//                                           : ElevatedButton(
//                                               style: ThemeRaclette
//                                                   .invertedButtonStyle,
//                                               onPressed: () async {
//                                                 await walletService
//                                                     .requestPermission();
//                                               },
//                                               child: Text(
//                                                 'Connect Wallet',
//                                                 style: ThemeRaclette
//                                                     .invertedButtonTextStyle,
//                                               ))),
//                                     )),
//                               ],
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _feeSelection(bool edit, int s) {
//     if (edit) {
//       return SizedBox(
//         width: 400,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             FeeTierCard('Best for very stable pairs.', feeTier[0], s == 0, () {
//               selected.value = 0;
//             }),
//             FeeTierCard('Best for stable pairs.', feeTier[1], s == 1, () {
//               selected.value = 1;
//             }),
//             FeeTierCard('Best for most pairs', feeTier[2], s == 2, () {
//               selected.value = 2;
//             }),
//             FeeTierCard('Best for exotic pairs.', feeTier[3], s == 3, () {
//               selected.value = 3;
//             }),
//           ],
//         ),
//       );
//     }

//     return const SizedBox();
//   }
// }
