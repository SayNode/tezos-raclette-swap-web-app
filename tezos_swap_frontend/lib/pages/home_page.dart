import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/pages/widgets/pool.dart';
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
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          const Expanded(child: SizedBox()),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
                color: ThemeRaclette.primaryStatic,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Row(
              children: [
                
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        index = 0;
                      });
                    },
                    child: const Text('Swap', style: TextStyle(fontSize: 24))),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: const Text('Pool', style: TextStyle(fontSize: 24))),
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
          const Expanded(child: SizedBox()),
        ],
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
}
