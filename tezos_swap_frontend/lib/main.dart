import 'package:flutter/material.dart';
import 'package:tezos_swap_frontend/repositories/token_repo.dart';
import 'pages/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'theme/ThemeRaclette.dart';
GetIt getIt = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
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
    return MaterialApp(
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
      home: const HomePage(),
    );
  }
}
