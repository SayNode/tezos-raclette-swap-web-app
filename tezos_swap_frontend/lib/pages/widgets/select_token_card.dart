import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/token.dart';
import '../../repositories/token_repo.dart';
import '../../theme/ThemeRaclette.dart';

class SelectTokenCard extends StatefulWidget {
  const SelectTokenCard({Key? key}) : super(key: key);

  @override
  State<SelectTokenCard> createState() => _SelectTokenCardState();
}

class _SelectTokenCardState extends State<SelectTokenCard> {
  TokenRepository tokenRepository = getIt.get<TokenRepository>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 400,
          height: 800,
          child: Card(
            color: Colors.red,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.green, width: 1.0),
                borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              children: [
                const Text('Select a Token'),
                const Divider(
                  color: Colors.white,
                ),
                FutureBuilder<List<Token>>(
                    future: tokenRepository.loadTokens(),
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
                          return ListTile(
                            onTap: () {
                              Navigator.pop(context, snapshot.data![index]);
                            },
                            leading: Image.asset(
                              snapshot.data![index].icon,
                              width: 25,
                            ),
                            title: Text(
                              snapshot.data![index].symbol,
                              style:
                                  const TextStyle(color: ThemeRaclette.black),
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