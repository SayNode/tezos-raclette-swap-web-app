import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import 'package:tezos_swap_frontend/utils/globals.dart';

import '../../services/new_position_service.dart';
import '../../theme/ThemeRaclette.dart';
import '../../utils/utils.dart';

class PositionsCard extends StatelessWidget {
  const PositionsCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                        FutureBuilder<List<Map>>(
                          future:
                              positionsOfAddress(
                                  walletProvider.address.string,
                                  testContract),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                      snapshot.data!.length,
                                      (index) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      '${getContractTokens(testContract)[0].symbol}/${getContractTokens(testContract)[1].symbol}'),
                                                  Text(
                                                      'Liquidity proivided: ${snapshot.data![index]['value']['liquidity']}'),
                                                  ElevatedButton(
                                                      onPressed: ()async {
                                                        await walletProvider.removePosition(testContract, snapshot.data![index]['key']);
                                                      },
                                                      child: const Text(
                                                          'Remove Position'))
                                                ],
                                              ),
                                            ),
                                          )

                                      // Container(
                                      //       color: Colors.green,
                                      //       child: Row(
                                      //         mainAxisSize: MainAxisSize.min,
                                      //         children: [
                                      //           Text(
                                      //               'Min: ${snapshot.data![index]['value']['lower_tick_index']}, '),
                                      //           Text(
                                      //               'Max: ${snapshot.data![index]['value']['upper_tick_index']}, '),
                                      //           Text(
                                      //               'Liquidity: ${snapshot.data![index]['value']['liquidity']}'),
                                      //         ],
                                      //       ),
                                      //     )
                                      ),
                                );
                              } else {
                                return const Text('Empty data');
                              }
                            } else {
                              return Text('State: ${snapshot.connectionState}');
                            }
                          },
                        ),
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
