import 'package:flutter/material.dart';

class RacletteCoinCard extends StatefulWidget {
  const RacletteCoinCard({Key? key, required this.coinName, required this.coinSubtitle, required this.coinLogo}) : super(key: key);

  final String coinName;
  final String coinSubtitle;
  final Icon coinLogo;

  @override
  State<RacletteCoinCard> createState() => _RacletteCoinCardState();
}

class _RacletteCoinCardState extends State<RacletteCoinCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: EdgeInsets.only(top: 6, left: 12, right: 12, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        widget.coinLogo,
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Text(widget.coinName),
          Text(widget.coinSubtitle),
        ],)
      ],),
    );
  }
}
