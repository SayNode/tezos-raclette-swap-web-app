import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FeeTierCard extends StatefulWidget {
  FeeTierCard(this.text, this.fee, {super.key});
  double fee;
  String text;

  @override
  State<FeeTierCard> createState() => _FeeTierCardState();
}

class _FeeTierCardState extends State<FeeTierCard> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 90,
        height: 100,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('${widget.fee}%'),
                const SizedBox(height: 10,),
                Text(
                  widget.text,
                  style: const TextStyle(fontSize: 12),
                )
              ],
            )),
      ),
    );
  }
}
