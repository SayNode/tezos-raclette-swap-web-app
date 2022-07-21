import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: (){

      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(
          maxWidth:  600,
        ),
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
                        ,child: Text('Transaction Settings', style: TextStyle(fontSize: 30),)),
                    SizedBox(height: 50,),
                    Text('Setting 1', style: TextStyle(fontSize: 24),),
                    Text('Setting 2', style: TextStyle(fontSize: 24),),
                    Text('Setting 3', style: TextStyle(fontSize: 24),)

                  ],
                ),
              ),
            ),
          );
        },
      );

    }, icon: Icon(Icons.settings, color: ThemeRaclette.white,));
  }
}