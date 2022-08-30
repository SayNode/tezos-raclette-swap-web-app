import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezos_swap_frontend/pages/pool/pool.dart';
import 'package:tezos_swap_frontend/pages/swap/swap.dart';
import 'package:tezos_swap_frontend/services/balance_provider.dart';
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
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Row(
          children: [
            const Expanded(child: SizedBox()),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                  color: ThemeRaclette.primaryStatic,
                  borderRadius: BorderRadius.all(Radius.circular(18))),
              child: Row(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: (index == 0) ? Colors.green : null,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(18))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              index = 0;
                            });
                          },
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.grey;
                              }
                              return Colors.black;
                            }),
                          ),
                          child: const Text('Swap',
                              style: TextStyle(fontSize: 24))),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: (index == 1) ? Colors.green : null,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(18))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              index = 1;
                            });
                          },
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.grey;
                              }
                              return Colors.black;
                            }),
                          ),
                          child: const Text('Pool',
                              style: TextStyle(fontSize: 24))),
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  const Text('Vote', style: TextStyle(fontSize: 24)),
                  const SizedBox(
                    width: 24,
                  ),
                  const Text('Chart', style: TextStyle(fontSize: 24)),
                ],
              ),
            ),
            Expanded(
                child: Align(
              alignment: Alignment.centerRight,
              child: Obx(() => _connectWallet(provider.address.string)),
            )),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: ThemeRaclette.white, gradient: ThemeRaclette.mainGradient),
        child: IndexedStack(
          index: index,
          children: [
            Swap(provider: provider),
            const Pool(),
            Swap(provider: provider),
            Swap(provider: provider)
          ],
        ),
      ),
    );
  }

  Widget _connectWallet(String address) {
    if (address.isNotEmpty) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(
              color: ThemeRaclette.primaryStatic,
              borderRadius: BorderRadius.all(Radius.circular(18))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 50,
              ),
              FutureBuilder<String>(
                  future: getBalance(address, 'https://mainnet.api.tez.ie/'),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text('Error');
                    }
                    return Text('${snapshot.data} XTZ');
                  }),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(18))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(address),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return ElevatedButton(
          style: ThemeRaclette.invertedButtonStyle,
          onPressed: () async {
            await provider.requestPermission();
          },
          child: Text(
            'Connect Wallet',
            style: ThemeRaclette.invertedButtonTextStyle,
          ));
    }
  }
}
