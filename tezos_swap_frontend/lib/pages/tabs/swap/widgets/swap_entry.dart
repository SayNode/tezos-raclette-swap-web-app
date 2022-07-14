import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/theme/ThemeRaclette.dart';

class SwapEntry extends StatefulWidget {
  const SwapEntry({
    Key? key,
    required this.upperController,
  }) : super(key: key);

  final TextEditingController upperController;

  @override
  State<SwapEntry> createState() => _SwapEntryState();
}

class _SwapEntryState extends State<SwapEntry> {
  TextEditingController searchCoinController = TextEditingController();

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
              controller: widget.upperController,
              decoration: InputDecoration.collapsed(hintText: '0.0', hintStyle: TextStyle(color: ThemeRaclette.white)),
              style: TextStyle(fontSize: 30, color: ThemeRaclette.white),
            ),
          ),
          TextButton(
              onPressed: (){
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
                                  ,child: Text('Select a token:', style: TextStyle(fontSize: 30),)),
                              SizedBox(height: 50,),
                              SizedBox(
                                width: 350,
                                child: TextField(
                                  controller: searchCoinController,
                                  style: TextStyle(color: ThemeRaclette.white),
                                  decoration: InputDecoration(
                                    labelText: 'Search name or paste address',
                                    labelStyle: TextStyle(color: ThemeRaclette.gray100),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: ThemeRaclette.white),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: ThemeRaclette.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                padding: EdgeInsets.all(8),
                                width: 400,
                                decoration: BoxDecoration(color: ThemeRaclette.gray900, borderRadius: BorderRadius.circular(12)),
                                child: SizedBox(
                                    width: 350,
                                    child: Text('Manage Token List.',
                                      style: TextStyle(color: ThemeRaclette.white, fontSize: 16, overflow: TextOverflow.clip) ,maxLines: 5,)),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
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