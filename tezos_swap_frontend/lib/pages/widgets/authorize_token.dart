import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';
import 'dart:html' as html;

import 'package:tezos_swap_frontend/utils/globals.dart';

class AuthorizeTokenCard extends StatefulWidget {
  const AuthorizeTokenCard({
    Key? key,
    required this.tokenAddress,
    required this.contractAddress,
  }) : super(key: key);
  final String tokenAddress;
  final String contractAddress;

  @override
  State<AuthorizeTokenCard> createState() => _AuthorizeTokenCardState();
}

class _AuthorizeTokenCardState extends State<AuthorizeTokenCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Container(
            width: 600,
            height: 500,
            margin: const EdgeInsets.symmetric(vertical: 200),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: ThemeRaclette.black,
                borderRadius: BorderRadius.circular(12)),
            child: Form(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Authorize Token',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {

                          walletProvider.authorizeContract(widget.tokenAddress, widget.contractAddress);

                        html.window.addEventListener("message", (event) {
                          final evt = (event as html.MessageEvent);
                          if (evt.source == html.window &&
                              evt.data['type'] == 'TEMPLE_PAGE_RESPONSE') {
                            Get.close(1);
                          } else if (evt.source == html.window &&
                              evt.data['type'] ==
                                  'TEMPLE_PAGE_ERROR_RESPONSE') {
                            debugPrint(evt.data);
                          }
                        }, true);
                      },
                      child: const Text('Authorize'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
