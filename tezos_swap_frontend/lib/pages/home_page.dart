import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/pages/tabs/swap/swap.dart';
import 'package:tezos_swap_frontend/pages/tabs/swap/widgets/wallet_connect_button.dart';
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
                    width: 280,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset("assets/image/logo_medium.png"),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    width: 500,
                    decoration: BoxDecoration(color: ThemeRaclette.black, borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: const TabBar(
                        tabs: [
                      Tab(child: Text('Swap', style: TextStyle(color: ThemeRaclette.white, fontSize: 24),)),
                      Tab(child: Text('Pool', style: TextStyle(color: ThemeRaclette.white, fontSize: 24))),
                      Tab(child: Text('Vote', style: TextStyle(color: ThemeRaclette.white, fontSize: 24))),
                      Tab(child: Text('Chart', style: TextStyle(color: ThemeRaclette.white, fontSize: 24))),
                    ]),
                  ),
                  SizedBox(
                    width: 280,
                    height: 60,
                    child: WalletConnectButton(),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.6,
              child: TabBarView(children: [
                Center(child: Swap(provider: provider)),
                Text('pool'),
                Text('vote'),
                Text('chart'),
              ]),
            ),
            // SizedBox(height: 40,),
            // AnimatedBuilder(
            //     animation: provider,
            //     builder: (context, child) {
            //       return Text(
            //         provider.address,
            //         style: Theme.of(context).textTheme.headline4,
            //       );
            //     }),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton(
            //       onPressed: () async {
            //         await provider.requestTransaction(1, 'tz1NzsDqmftLqQSNZ5w17ssAmvHHRhuMy7mg', 'KT1K16JFj1L5u4HqVtd4H8dnaBVUxvLG4mjR');
            //       },
            //       child: Text('call contract')),
            // ),

          ],
        ),
      ),
    );
  }
}
