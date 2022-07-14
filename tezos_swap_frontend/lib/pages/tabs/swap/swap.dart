import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/pages/tabs/swap/widgets/settings_button.dart';
import 'package:tezos_swap_frontend/pages/tabs/swap/widgets/swap_entry.dart';
import 'package:tezos_swap_frontend/pages/tabs/swap/widgets/wallet_connect_button.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';

class Swap extends StatefulWidget {
  final WalletProvider provider;
  const Swap({
    Key? key, required this.provider,
  }) : super(key: key);

  @override
  State<Swap> createState() => _SwapState();
}

class _SwapState extends State<Swap> {
  TextEditingController upperController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      height: 400,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: ThemeRaclette.black,
          borderRadius: BorderRadius.circular(12)
      ),
      child: Form(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Swap', style: TextStyle(fontSize: 20),),
                SettingsButton()
              ],
            ),
            SwapEntry(upperController: upperController),
            SizedBox(height: 15,),
            SwapEntry(upperController: upperController),
            SizedBox(height: 30,),
            SizedBox(
              width: double.infinity,
              height: 60,
                child: WalletConnectButton(),
            ),
          ],
        ),
      ) ,
    );
  }
}


