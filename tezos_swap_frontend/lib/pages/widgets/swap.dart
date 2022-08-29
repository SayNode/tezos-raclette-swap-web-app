import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';


class Swap extends StatefulWidget {
  final WalletProvider provider;
  const Swap({
    Key? key, required this.provider,
  }) : super(key: key);

  @override
  State<Swap> createState() => _SwapState();
}

class _SwapState extends State<Swap> {
  TextEditingController upperController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 600,
        height: 400,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: ThemeRaclette.black,
            borderRadius: BorderRadius.circular(12)
        ),
        child: Form(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Swap', style: TextStyle(fontSize: 20),),
                  IconButton(onPressed: (){
                    debugPrint('pressing settings');
                  }, icon: Icon(Icons.settings, color: ThemeRaclette.white,))
                ],
              ),
              SwapEntry(upperController: upperController),
              SizedBox(height: 15,),
              SwapEntry(upperController: upperController),
              SizedBox(height: 30,),
              SizedBox(
                width: double.infinity,
                height: 60,
                  child: ElevatedButton(
                      style: ThemeRaclette.invertedButtonStyle,
                      onPressed: () async {
                        await widget.provider.requestPermission();
                      },
                      child: Text(
                        'connect'.tr(),
                        style: ThemeRaclette.invertedButtonTextStyle,
                      )),
              ),
            ],
          ),
        ) ,
      ),
    );
  }
}

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
