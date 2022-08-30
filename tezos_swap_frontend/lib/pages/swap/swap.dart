import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezos_swap_frontend/pages/widgets/token_select_button.dart';
import 'package:tezos_swap_frontend/services/token_provider.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';
import '../../models/token.dart';
import '../../utils/globals.dart';

class Swap extends StatefulWidget {
  final WalletProvider provider;
  const Swap({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  State<Swap> createState() => _SwapState();
}

class _SwapState extends State<Swap> {
  TextEditingController upperController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 600,
        height: 400,
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
                    'Swap',
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
              SwapEntry(upperController: upperController),
              const SizedBox(
                height: 15,
              ),
              SwapEntry(upperController: upperController),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: Obx(() => _connectWallet(walletProvider.address.string)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _connectWallet(String address) {
    if (address.isNotEmpty) {
      return ElevatedButton(
        style: ThemeRaclette.invertedButtonStyle,
        onPressed: () async {
          await widget.provider.requestPermission();
        },
        child: Text(
          'Swap',
          style: ThemeRaclette.invertedButtonTextStyle,
        ));
    }
    return ElevatedButton(
        style: ThemeRaclette.invertedButtonStyle,
        onPressed: () async {
          await widget.provider.requestPermission();
        },
        child: Text(
          'Connect Wallet',
          style: ThemeRaclette.invertedButtonTextStyle,
        ));
  }
}

class SwapEntry extends StatefulWidget {
  const SwapEntry({
    Key? key,
    required this.upperController,
  }) : super(key: key);

  final TextEditingController upperController;

  @override
  State<SwapEntry> createState() => _SwapEntryState();
}

class _SwapEntryState extends State<SwapEntry> {
  Token? token;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      height: 100,
      decoration: BoxDecoration(
          color: ThemeRaclette.gray500,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 300,
            height: 30,
            child: TextFormField(
              controller: widget.upperController,
              decoration: const InputDecoration.collapsed(
                  hintText: '0.0',
                  hintStyle: TextStyle(color: ThemeRaclette.white)),
              style: const TextStyle(fontSize: 30, color: ThemeRaclette.white),
            ),
          ),
          TokenSelectButton(TokenProvider()),
        ],
      ),
    );
  }
}
