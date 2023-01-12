import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import 'package:tezos_swap_frontend/utils/globals.dart';
import 'package:tezos_swap_frontend/utils/utils.dart';

class TestWalletInteraction extends StatefulWidget {
  TestWalletInteraction({super.key});

  @override
  State<TestWalletInteraction> createState() => _TestWalletInteractionState();
}

class _TestWalletInteractionState extends State<TestWalletInteraction> {
  final provider = WalletProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Obx(() {
            if (provider.address.string.isEmpty) {
              return Text(
                'Connected Wallet: Not Connected',
                style: TextStyle(fontSize: 20),
              );
            } else {
              return Text(
                'Connected Wallet: ${provider.address.string}',
                style: TextStyle(fontSize: 20),
              );
            }
          }),
          ElevatedButton(
              onPressed: () async {
                await provider.requestPermission();
              },
              child: Text('Connect Wallet')),
          SizedBox(
            height: 20,
          ),
          Text('set position with 100 x, 100y and min 1, max 20'),
          ElevatedButton(
              onPressed: () async {
                await provider.setPosition(
                    'KT1TZTkhnZFPL7cdNaif9B3r5oQswM1pnCXB',
                    provider.address.string,
                    double.parse('100000000000000000000'),
                    double.parse('100000000000000000000'),
                    1,
                    20);
              },
              child: Text('Test set_position')),
          SizedBox(
            height: 20,
          ),
          Text('swap 10x for min 1y'),
          ElevatedButton(
              onPressed: () async {
                await provider.swap('KT1TZTkhnZFPL7cdNaif9B3r5oQswM1pnCXB',
                    provider.address.string, BigInt.from(10), BigInt.from(1));
              },
              child: Text('swap x->y')),
          SizedBox(
            height: 20,
          ),
          Text('swap 10y for min 1x'),
          ElevatedButton(
              onPressed: () async {
                await provider.swap('KT1TZTkhnZFPL7cdNaif9B3r5oQswM1pnCXB',
                    provider.address.string, BigInt.from(1), BigInt.from(10),
                    yToX: true);
              },
              child: Text('swap y->x')),
          ElevatedButton(
              onPressed: () async {
                var lowerPrice = 4;
                var lowerTick = logBase(lowerPrice, 1.0001);
                print(lowerPrice);
                var currentTick =
                   await getCurrentTick('KT1TZTkhnZFPL7cdNaif9B3r5oQswM1pnCXB');
                   var res = await getLiquidity(5, lowerTick.toInt(), currentTick, 18);
                   print(fractionToFullToken(21.18, 18));
                   print(res);
              },
              child: Text('Test'))
        ],
      )),
    );
  }
}

double logBase(int x, double base) => log(x) / log(base);

//100000.000000000123142256     99999.80509984167719272
//100000.000000000123142256     99999.710149700016775194
//100000.000000000123142256     99999.710149700016775193
//100000.000000000123142256     99999.710149700016775192
//100000.000000000123142256     99999.710149700016775191
