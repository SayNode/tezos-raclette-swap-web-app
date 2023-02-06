import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/token.dart';
import '../../../services/token_provider.dart';
import '../../../theme/ThemeRaclette.dart';

// ignore: must_be_immutable
class PriceCard extends StatefulWidget {
  Token? token1;
  Token? token2;
  RxInt price;
  String text;
  bool enabled;
  final TextEditingController controller;
  void Function(String) onChanged;
  PriceCard(this.text, this.token1, this.token2, this.price, this.enabled,
      this.onChanged,
      {super.key, required this.controller});

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
                      onPressed: () {
                        widget.price.value = widget.price.value - 1;
                      },
                      icon: const Icon(Icons.remove),
                      color: Colors.white),
                ),
                SizedBox(
                    width: 100,
                    child: Obx(() {
                      widget.controller.value = TextEditingValue(
                        text: widget.price.value.toString(),
                        selection: TextSelection.collapsed(
                            offset: widget.price.value.toString().length),
                      );

                      // widget.price.value.toString();
                      return TextField(
                        enabled: widget.enabled,
                        controller: widget.controller,
                        onChanged: (value) {
                          widget.onChanged(value);
                        },
                      );
                    })),
                Expanded(
                  child: IconButton(
                      onPressed: () {
                        widget.price.value = widget.price.value + 1;
                      },
                      icon: const Icon(Icons.add),
                      color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: (widget.token1 != null)
                      ? Text(
                          widget.token1!.symbol,
                          style: const TextStyle(color: ThemeRaclette.white),
                        )
                      : const SizedBox(),
                ),
                const Text(
                  ' per ',
                  style: TextStyle(color: ThemeRaclette.white),
                ),
                Expanded(
                  child: (widget.token2 != null)
                      ? Text(
                          widget.token2!.symbol,
                          style: const TextStyle(color: ThemeRaclette.white),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
