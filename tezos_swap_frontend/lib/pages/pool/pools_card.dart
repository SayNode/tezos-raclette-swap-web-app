import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/pages/pool/new_position_card.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';

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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
