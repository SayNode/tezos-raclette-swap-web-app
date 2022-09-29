import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/models/contract_model.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';
import '../../models/token.dart';
import '../../utils/globals.dart';
import '../../utils/utils.dart';

class VotePage extends StatefulWidget {
  const VotePage({
    Key? key,
  }) : super(key: key);

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  TextEditingController upperController = TextEditingController();
  Token? token1;
  Token? token2;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 600,
          height: 500,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: ThemeRaclette.black,
              borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: ElevatedButton(
                onPressed: () async {
                  // walletProvider.setPosition(
                  //     'KT1G49NuztmWBP6sMFZM259RCkg6eeFpbYp7',
                  //     walletProvider.address.string);
                 // walletProvider.swap('KT1G49NuztmWBP6sMFZM259RCkg6eeFpbYp7', 'tz1NyKro1Qi2cWd66r91BwByT5gxyBoWSrFf', 3, 1);
                },
                child: Text(
                  'coming soon...',
                  style: TextStyle(fontSize: 24),
                )),
          )),
    );
  }
}
