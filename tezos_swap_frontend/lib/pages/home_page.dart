import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezos_swap_frontend/pages/pool/pool.dart';
import 'package:tezos_swap_frontend/pages/swap/swap.dart';
import 'package:tezos_swap_frontend/pages/vote/vote_page.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';
import '../services/balance_provider.dart';
import '../utils/globals.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> photos = [
    "assets/image/BG1.jpg",
    "assets/image/BG2.jpg",
    "assets/image/BG3.jpg",
    "assets/image/BG4.jpg",
    "assets/image/BG5.jpg",
  ];
  int _pos = 0;
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        _pos = (_pos + 1) % photos.length;
      });
    });
    super.initState();
  }

  String? adr;
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.black,
        shadowColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 100,
                  child: Image(image: AssetImage("assets/image/logo_1.png")),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
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
                        border: (index == 0)
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
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
                          child: Text('Swap',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: (index == 0)
                                      ? Colors.white
                                      : Colors.black))),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: (index == 1)
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
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
                          child: Text('Pool',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: (index == 1)
                                      ? Colors.white
                                      : Colors.black))),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: (index == 2)
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(18))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              index = 2;
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
                          child: Text('Vote',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: (index == 2)
                                      ? Colors.white
                                      : Colors.black))),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Align(
              alignment: Alignment.centerRight,
              child: Obx(() => _connectWallet(walletProvider.address.string)),
            )),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.asset(
                  photos[_pos],
                  gaplessPlayback: true,
                ).image,
                fit: BoxFit.cover)),
        child: IndexedStack(
          index: index,
          children: [
            Swap(provider: walletProvider),
            Pool(provider: walletProvider),
            const VotePage()
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
                  future: BalanceProvider.getBalanceTezos(
                      address, 'https://mainnet.api.tez.ie/'),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Text('Error');
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
            await walletProvider.requestPermission();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Connect Wallet',
              style: ThemeRaclette.invertedButtonTextStyle,
            ),
          ));
    }
  }
}
