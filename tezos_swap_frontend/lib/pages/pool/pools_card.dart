import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/pages/pool/new_position_card.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';
import 'package:tezos_swap_frontend/utils/globals.dart';
import 'package:tezos_swap_frontend/utils/utils.dart';

class PoolCard extends StatefulWidget {
  final WalletProvider provider;
  const PoolCard({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  State<PoolCard> createState() => _PoolCardState();
}

class _PoolCardState extends State<PoolCard> {
  bool newPosition = false;
  @override
  Widget build(BuildContext context) {
    return (newPosition)
        ? NewPositionCard(provider: widget.provider)
        : Center(
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 200),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      color: ThemeRaclette.black,
                      borderRadius: BorderRadius.circular(12)),
                  child: Form(
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Pool',
                              style: TextStyle(fontSize: 20),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    newPosition = true;
                                  });
                                },
                                child: const Text('New Position'))
                          ],
                        ),
                        FutureBuilder<List<Map>>(
                          future:
                              //positionsOfAddress(walletProvider.address.string),
                              positionsOfAddress(
                                  'tz1NyKro1Qi2cWd66r91BwByT5gxyBoWSrFf'),
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<List<Map>> snapshot,
                          ) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Text('Error');
                              } else if (snapshot.hasData) {
                                return Container(
                                  color: Colors.red,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                        snapshot.data!.length,
                                        (index) => Container(
                                              color: Colors.green,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      'Min: ${snapshot.data![index]['value']['lower_tick_index']}, '),
                                                  Text(
                                                      'Max: ${snapshot.data![index]['value']['upper_tick_index']}, '),
                                                  Text(
                                                      'Liquidity: ${snapshot.data![index]['value']['liquidity']}'),
                                                ],
                                              ),
                                            )),
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
              ),
            ),
          );
  }
}
