import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';
import 'package:tezos_swap_frontend/utils/utils.dart';
import '../../models/token.dart';
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
                  var a = await buildChartPoints();
                },
                child: const Text(
                  'coming soon...',
                  style: TextStyle(fontSize: 24),
                )),
          )),
    );
  }
}
