import 'package:flutter/material.dart';
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
    return const Center(
      child: Text('coming soon...', style: TextStyle(fontSize: 24),),
    );
  }
}
