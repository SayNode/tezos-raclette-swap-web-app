import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1000,
        height: 700,
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
                    'Add Liquidity',
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
              const Divider(
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: const [
                      Text(
                        'Select Pair',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Column(
                    children: const [
                      Text(
                        'Select Price Range',
                        style: TextStyle(fontSize: 14),
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
