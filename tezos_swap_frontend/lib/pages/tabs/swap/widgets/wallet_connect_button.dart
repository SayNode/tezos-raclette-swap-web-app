import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tezos_swap_frontend/pages/tabs/swap/swap.dart';

import '../../../../theme/ThemeRaclette.dart';

class WalletConnectButton extends StatelessWidget {
  const WalletConnectButton({
    Key? key,
  }) : super(key: key);

  final String wallet1 = 'MetaMask';
  final String iconLink1 = 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/MetaMask_Fox.svg/512px-MetaMask_Fox.svg.png?20201112074605';

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ThemeRaclette.invertedButtonStyle,
        onPressed: () async {
          // await widget.provider.requestPermission();
          showModalBottomSheet<void>(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(color: ThemeRaclette.gray500,borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(8)
                        ,child: Text('Choose the wallet you want to connect:', style: TextStyle(fontSize: 30),)),
                        SizedBox(height: 50,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: WalletConfirmButton(wallet: wallet1, iconLink: this.iconLink1,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: WalletConfirmButton(wallet: wallet1, iconLink: this.iconLink1,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: WalletConfirmButton(wallet: wallet1, iconLink: this.iconLink1,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: WalletConfirmButton(wallet: wallet1, iconLink: this.iconLink1,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: 400,
                            decoration: BoxDecoration(color: ThemeRaclette.gray900, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 350, child: Text('By connecting a wallet, you agree to SayNode’ Terms of Service and acknowledge that you have read and understand the Saynode Protocol Disclaimer.', style: TextStyle(color: ThemeRaclette.white, fontSize: 16, overflow: TextOverflow.clip) ,maxLines: 5,)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );


        },
        child: Text(
          'connect'.tr(),
          style: ThemeRaclette.invertedButtonTextStyle,
        ));
  }
}

class WalletConfirmButton extends StatelessWidget {

  const WalletConfirmButton({
    Key? key,
    required this.wallet,
    required this.iconLink,
  }) : super(key: key);

  final String wallet;
  final String iconLink;

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () {
      debugPrint('choosing ' + wallet);
    }, child: Container(padding: EdgeInsets.all(8),
      decoration: BoxDecoration(color: ThemeRaclette.gray900, borderRadius: BorderRadius.circular(12)),
      width: 400,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(wallet, style: TextStyle(color: ThemeRaclette.white, fontSize: 24),),
          Image.network(iconLink, height: 30,)
        ],
      ),
    ));
  }
}

