import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/pages/widgets/swap.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';

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
        decoration: const BoxDecoration(color: ThemeRaclette.white, gradient: ThemeRaclette.mainGradient),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset("assets/image/logo_medium.png"),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(color: ThemeRaclette.black, borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(color: ThemeRaclette.gray500, borderRadius: BorderRadius.all(Radius.circular(12))),
                          child: Text(
                            'Swap',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Text('Pool', style: TextStyle(fontSize: 24)),
                        SizedBox(
                          width: 24,
                        ),
                        Text('Vote', style: TextStyle(fontSize: 24)),
                        SizedBox(
                          width: 24,
                        ),
                        Text('Chart', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    height: 60,
                      child: ElevatedButton(
                          style: ThemeRaclette.invertedButtonStyle,
                          onPressed: () async {
                            await provider.requestPermission();
                          },
                          child: Text(
                            'connect'.tr(),
                            style: ThemeRaclette.invertedButtonTextStyle,
                          )),
                  ),
                ],
              ),
            ),
            Swap(provider: provider),
            SizedBox(height: 40,),
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
                    await provider.requestTransaction(1, 'tz1NzsDqmftLqQSNZ5w17ssAmvHHRhuMy7mg', 'KT1K16JFj1L5u4HqVtd4H8dnaBVUxvLG4mjR');
                  },
                  child: Text('call contract')),
            ),

          ],
        ),
      ),
    );
  }
}
