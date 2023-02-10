import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezos_swap_frontend/pages/pool/controllers/positions_controller.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import 'package:tezos_swap_frontend/utils/globals.dart';

import 'controllers/new_position_service.dart';
import '../../theme/ThemeRaclette.dart';
import '../../utils/utils.dart';

class PositionsCard extends GetView<PositionsController> {
  PositionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PositionsController());
    var walletProvider = Get.put(WalletService());
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
                            const Text(
                              'Pool',
                              style: TextStyle(fontSize: 24),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Get.put(NewPositionService())
                                      .newPosition
                                      .value = true;
                                },
                                child: const Text('New Position'))
                          ],
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        // Obx(() {
                        //   return Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: List.generate(
                        //         controller.positions.length,
                        //         (index) => Padding(
                        //               padding: const EdgeInsets.all(8.0),
                        //               child: ListTile(
                        //                 title: Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceBetween,
                        //                   children: [
                        //                     Text(
                        //                         '${getContractTokens(testContract)[0].symbol}/${getContractTokens(testContract)[1].symbol}'),
                        //                     Text(
                        //                         'Liquidity proivided: ${smallToFull(BigInt.parse(controller.positions.value[index]['value']['liquidity']), 18)}'),
                        //                     ElevatedButton(
                        //                         onPressed: () async {
                        //                           await walletProvider
                        //                               .removePosition(
                        //                                   testContract,
                        //                                   controller.positions
                        //                                       .value[index]);
                        //                         },
                        //                         child: const Text(
                        //                             'Remove Position'))
                        //                   ],
                        //                 ),
                        //               ),
                        //             )),
                        //   );
                        // })
                        Obx(() {
                          return FutureBuilder<List<Map>>(
                            future: positionsOfAddress(
                                walletProvider.address.string, testContract),
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<List<Map>> snapshot,
                            ) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return const Text('Error');
                                } else if (snapshot.hasData) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                        snapshot.data!.length,
                                        (index) => Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        '${getContractTokens(testContract)[0].symbol}/${getContractTokens(testContract)[1].symbol}'),
                                                    Text(
                                                        'Liquidity proivided: ${smallToFull(BigInt.parse(snapshot.data![index]['value']['liquidity']), 18).toStringAsFixed(2)}'),
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          await walletProvider
                                                              .removePosition(
                                                                  testContract,
                                                                  snapshot.data![
                                                                      index]);
                                                        },
                                                        child: const Text(
                                                            'Remove Position'))
                                                  ],
                                                ),
                                              ),
                                            )),
                                  );
                                } else {
                                  return const Text('Empty data');
                                }
                              } else {
                                return Text(
                                    'State: ${snapshot.connectionState}');
                              }
                            },
                          );
                        }),
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
