import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/token.dart';
import '../../../services/token_provider.dart';
import '../../../theme/ThemeRaclette.dart';

// ignore: must_be_immutable
class PriceCard extends StatefulWidget {
  TokenProvider token1;
  TokenProvider token2;
  RxDouble price;
  String text;
  PriceCard(this.text, this.token1, this.token2, this.price, {super.key});

  @override
  State<PriceCard> createState() => _PriceCardState();
}

class _PriceCardState extends State<PriceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: const TextStyle(color: ThemeRaclette.white),
            ),
            Row(
              children: [
                Expanded(
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.remove),
                      color: Colors.white),
                ),
                Obx(() => Text("${widget.price.value}")),
                Expanded(
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: widget.token1,
                      builder: (context, value, child) {
                        if (widget.token1.token != null) {
                          return Text(
                            widget.token1.token!.symbol,
                            style: const TextStyle(color: ThemeRaclette.white),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                ),
                const Text(
                  ' per ',
                  style: TextStyle(color: ThemeRaclette.white),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: widget.token2,
                      builder: (context, value, child) {
                        if (widget.token2.token != null) {
                          return Text(
                            widget.token2.token!.symbol,
                            style: const TextStyle(color: ThemeRaclette.white),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
