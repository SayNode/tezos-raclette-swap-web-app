import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezos_swap_frontend/pages/pool/pools_card.dart';
import 'package:tezos_swap_frontend/pages/swap/swap_page.dart';
import 'package:tezos_swap_frontend/pages/vote/vote_page.dart';
import '../services/balance_provider.dart';
import '../services/wallet_connection.dart';
import '../theme/ThemeRaclette.dart';
import '../utils/globals.dart';
import '../utils/utils.dart';
import 'controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    var walletService = Get.put(WalletService());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: ThemeRaclette.black,
        shadowColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 80,
                      child: const Image(
                          image: AssetImage("assets/image/Logo.png")),
                    ),
                    Text(
                      'v.0.0.5',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: ThemeRaclette.primaryStatic,
                  borderRadius: BorderRadius.all(Radius.circular(18))),
              child: Row(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Obx(() {
                    return Container(
                      decoration: BoxDecoration(
                          border: (controller.index.value == 0)
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(18))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {
                              controller.index.value = 0;
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
                                    color: (controller.index.value == 0)
                                        ? Colors.white
                                        : Colors.black))),
                      ),
                    );
                  }),
                  Obx(() {
                    return Container(
                      decoration: BoxDecoration(
                          border: (controller.index.value == 1)
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(18))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {
                              controller.index.value = 1;
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
                                    color: (controller.index.value == 1)
                                        ? Colors.white
                                        : Colors.black))),
                      ),
                    );
                  }),
                  Obx(() {
                    return Container(
                      decoration: BoxDecoration(
                          border: (controller.index.value == 2)
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(18))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {
                              controller.index.value = 2;
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
                                    color: (controller.index.value == 2)
                                        ? Colors.white
                                        : Colors.black))),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Expanded(
                child: Align(
              alignment: Alignment.centerRight,
              child:
                  Obx(() => _connectWalletButton(walletService.address.string)),
            )),
          ],
        ),
      ),
      body: Stack(children: [
        Obx((() => Container(
              color: Colors.black,
              width: double.infinity,
              child: AnimatedSwitcher(
                duration: const Duration(seconds: 2),
                child: SizedBox.expand(
                  key: UniqueKey(),
                  child: Image.asset(
                    "assets/image/BG (${controller.pos.value}).jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ))),
        Obx(() {
          return IndexedStack(
            index: controller.index.value,
            children: [SwapPage(), PoolCard(), const VotePage()],
          );
        }),
      ]),
    );
  }

  Widget _connectWalletButton(String address) {
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
              // FutureBuilder<String>(
              //     future: BalanceProvider.getBalanceTezos(
              //         address, 'https://api.ghostnet.tzkt.io'),
              //     builder:
              //         (BuildContext context, AsyncSnapshot<String> snapshot) {
              //       if (!snapshot.hasData) {
              //         return const Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       }
              //       if (snapshot.hasError) {
              //         return const Text('Error');
              //       }
              //       return Text('${snapshot.data} XTZ');
              //     }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(addressToDisplayAddress(address)),
              )
            ],
          ),
        ),
      );
    } else {
      return ElevatedButton(
          style: ThemeRaclette.invertedButtonStyle,
          onPressed: () async {
            await Get.put(WalletService()).requestPermission();
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
