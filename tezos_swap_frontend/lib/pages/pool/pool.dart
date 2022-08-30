import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/pages/widgets/token_select_button.dart';
import 'package:tezos_swap_frontend/services/token_provider.dart';

import '../../models/token.dart';
import '../../theme/ThemeRaclette.dart';

class Pool extends StatefulWidget {
  const Pool({
    Key? key,
  }) : super(key: key);

  @override
  State<Pool> createState() => _PoolState();
}

class _PoolState extends State<Pool> {
  TextEditingController upperController = TextEditingController();
  Token? token1;
  Token? token2;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 700,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: ThemeRaclette.black,
            borderRadius: BorderRadius.circular(12)),
        child: IntrinsicWidth(
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
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TokenSelectButton(TokenProvider()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TokenSelectButton(TokenProvider()),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Select Price Range',
                        style: TextStyle(fontSize: 20),
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
