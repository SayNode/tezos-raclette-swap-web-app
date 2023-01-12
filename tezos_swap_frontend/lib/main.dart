import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezos_swap_frontend/pages/test_page.dart';
import 'package:tezos_swap_frontend/repositories/contract_repo.dart';
import 'package:tezos_swap_frontend/repositories/token_repo.dart';
import 'package:tezos_swap_frontend/utils/globals.dart' as global;
import 'package:tezos_swap_frontend/utils/test_wallet_interaction_page.dart';
import 'pages/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'theme/ThemeRaclette.dart';

GetIt getIt = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  global.contracts = await ContractRepository().loadContracts();
  getIt.registerSingleton<TokenRepository>(TokenRepository(),
      signalsReady: true);

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('de')],
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: const Locale('en'),
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var tokenRepo = Get.put(TokenRepository());
    var contractRepo = Get.put(ContractRepository());
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
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: 
      
      //TestWalletInteraction()
      
      FutureBuilder<List<dynamic>>(
        future: Future.wait([tokenRepo.init(), contractRepo.init()]),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: const TextStyle(fontSize: 18),
                ),
              );

              // if we got our data
            } else if (snapshot.hasData) {
              return const HomePage();
            }
          }
          return const Center(
            child: Text('Fatal Error, this should never happen.'),
          );
        },
      ),
    );
  }
}
