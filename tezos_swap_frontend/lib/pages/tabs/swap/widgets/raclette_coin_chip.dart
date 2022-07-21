import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';


class RacletteCoinChip extends StatefulWidget {

  const RacletteCoinChip({
    Key? key,
    required this.coinIcon,
    required this.coinName,
  }) : super(key: key);

  final Icon coinIcon;
  final String coinName;

  @override
  State<RacletteCoinChip> createState() => _RacletteCoinChipState();
}

class _RacletteCoinChipState extends State<RacletteCoinChip> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.only(top: 2, left: 2, right: 2, bottom: 2),
      width: 80,
      decoration: BoxDecoration(
          color: isHover ? ThemeRaclette.primaryStatic : ThemeRaclette.gray500,
          borderRadius: BorderRadius.circular(12),
      ),
      duration: Duration(milliseconds: 1000),
      child: InkWell(
        onTap: (){},
        onHover: (val) {
          setState(() {
            this.isHover = val;
          });
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(color: ThemeRaclette.gray250, borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.coinIcon,
                  Text(widget.coinName, style: TextStyle(color: ThemeRaclette.white, fontSize: 16, overflow: TextOverflow.clip) ,maxLines: 5,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}