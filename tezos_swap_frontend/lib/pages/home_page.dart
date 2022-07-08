import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import '../services/contract_caller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WalletProvider provider = WalletProvider();
  String? adr;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  await provider.requestPermission();
                },
                child: Text('connect'.tr())),
          ),
          AnimatedBuilder(
              animation: provider,
              builder: (context, child) {
                return Text(
                  provider.address,
                  style: Theme.of(context).textTheme.headline4,
                );
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  await callContract();
                },
                child: Text('call contract')),
          ),
        ],
      )),
    );
  }
}
