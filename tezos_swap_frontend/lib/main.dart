import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezos_swap_frontend/pages/home_page.dart';
import 'package:tezos_swap_frontend/services/contract_service.dart';
import 'package:tezos_swap_frontend/services/token_service.dart';
import 'package:tezos_swap_frontend/services/wallet_connection.dart';
import 'package:url_strategy/url_strategy.dart';
import 'localization/languages.dart';
import 'theme/ThemeRaclette.dart';
void main() async {
  //Remove # from URL
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

//Load needed assets before first page is displayd
  var tokenRepo = Get.put(TokenService());
  var contractRepo = Get.put(ContractService());
  Get.put(WalletService());
  await tokenRepo.init();
  await contractRepo.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(WalletService());
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Raclette Swap',
        theme: ThemeData(
            primarySwatch: ThemeRaclette().primaryColor(),
            fontFamily: 'Monument',
            scaffoldBackgroundColor: ThemeRaclette.black,
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: ThemeRaclette.white,
                  displayColor: ThemeRaclette.white,
                )),
        translations: Languages(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'US'),
        home: const HomePage());
  }
}
