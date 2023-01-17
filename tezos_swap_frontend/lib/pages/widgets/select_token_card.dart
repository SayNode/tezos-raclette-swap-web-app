import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../models/token.dart';
import '../../services/token_service.dart';
import '../../theme/ThemeRaclette.dart';

class SelectTokenCard extends StatefulWidget {
  const SelectTokenCard({Key? key}) : super(key: key);

  @override
  State<SelectTokenCard> createState() => _SelectTokenCardState();
}

class _SelectTokenCardState extends State<SelectTokenCard> {
  TokenService tokenService = Get.put(TokenService());
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 400,
          height: 500,
          child: Card(
            color: ThemeRaclette.primaryStatic,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: const Text(
                    'Select a Token',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 2,
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<Token>>(
                    future: tokenService.loadTokens(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Token>> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        primary: false,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                            right: 20, left: 20, bottom: 20),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 2),
                            child: ListTile(
                              hoverColor: ThemeRaclette.white,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(20.0)),
                              onTap: () {
                                Navigator.pop(context, snapshot.data![index]);
                              },
                              leading: Image.asset(
                                snapshot.data![index].icon,
                                width: 25,
                                color: ThemeRaclette.black,
                              ),
                              title: Text(
                                snapshot.data![index].symbol,
                                style:
                                    const TextStyle(color: ThemeRaclette.black),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
