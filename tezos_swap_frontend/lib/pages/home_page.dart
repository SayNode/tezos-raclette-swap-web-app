import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';
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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: ThemeRaclette.mainGradient
        ),
        child: Column(
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset("assets/image/logo_medium.png"),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(              color: ThemeRaclette.black,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Row(
                children: [
                  Text('Swap', style: TextStyle(fontSize: 24),),
                  SizedBox(width: 24,),
                  Text('Pool', style: TextStyle(fontSize: 24)),SizedBox(width: 24,),
                  Text('Vote', style: TextStyle(fontSize: 24)),SizedBox(width: 24,),
                  Text('Chart', style: TextStyle(fontSize: 24)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                style: ThemeRaclette.invertedButtonStyle,
                  onPressed: () async {
                    await provider.requestPermission();
                  },
                  child: Text('connect'.tr(), style: ThemeRaclette.invertedButtonTextStyle,)),
            ),
          ],
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
      ),
      ),
    );
  }
}
