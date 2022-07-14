import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';

class SwapEntry extends StatelessWidget {
  const SwapEntry({
    Key? key,
    required this.upperController,
  }) : super(key: key);

  final TextEditingController upperController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      height: 100,
      decoration: BoxDecoration(color: ThemeRaclette.gray500, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 300,
            height: 30,
            child: TextFormField(
              controller: upperController,
              decoration: InputDecoration.collapsed(hintText: '0.0', hintStyle: TextStyle(color: ThemeRaclette.white)),
              style: TextStyle(fontSize: 30, color: ThemeRaclette.white),
            ),
          ),
          TextButton(
              onPressed: (){
                debugPrint('pressing change coin');
              },
              style: ThemeRaclette.buttonStyle,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/image/eth_logo_black.png', width: 25,),
                    Text('ETH', style: TextStyle(color: ThemeRaclette.black),),
                    Icon(Icons.arrow_drop_down_outlined, color: ThemeRaclette.black,)
                  ],
                ),
              )),


        ],
      ),
    );
  }
}