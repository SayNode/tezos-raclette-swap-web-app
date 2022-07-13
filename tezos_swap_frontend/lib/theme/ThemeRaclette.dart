import 'package:flutter/material.dart';

class ThemeRaclette {
  // singleton setting
  static final ThemeRaclette _ThemeRaclette = ThemeRaclette._internal();

  factory ThemeRaclette() {
    return _ThemeRaclette;
  }
  ThemeRaclette._internal();

  // material color setup
  Map<int, Color> primaryColorShades = {
    50: const Color.fromRGBO(245, 168, 14, .1),
    100: const Color.fromRGBO(245, 168, 14, .2),
    200: const Color.fromRGBO(245, 168, 14, .3),
    300: const Color.fromRGBO(245, 168, 14, .4),
    400: const Color.fromRGBO(245, 168, 14, .5),
    500: const Color.fromRGBO(245, 168, 14, .6),
    600: const Color.fromRGBO(245, 168, 14, .7),
    700: const Color.fromRGBO(245, 168, 14, .8),
    800: const Color.fromRGBO(245, 168, 14, .9),
    900: const Color.fromRGBO(245, 168, 14, 1)
  };

  MaterialColor primaryColor() {
    return MaterialColor(0xFFF5A80E, primaryColorShades);
  }

  // constant colors
  static const Color white = Color.fromARGB(255, 254, 254, 254);
  static const Color black = Color.fromARGB(255, 5, 5, 5);
  static const Color gray900 = Color.fromARGB(255, 40, 40, 40);
  static const Color gray500 = Color.fromARGB(255, 77, 77, 77);
  static const Color gray250 = Color.fromARGB(255, 120, 120, 120);
  static const Color gray100 = Color.fromARGB(255, 203, 204, 206);
  static const Color grayCardLeft = Color.fromRGBO(32, 32, 52, .6);
  static const Color grayCardRight = Color.fromRGBO(60, 56, 56, .6);
  static const Color whiteCardBorder = Color.fromRGBO(255, 255, 255, .3);
  static const Color primaryStatic = Color.fromRGBO(245, 168, 14, 1);
  static const Color evenNumberColor = Color.fromARGB(255, 55, 55, 55);
  static const Color invertedButtonBackground = Color.fromARGB(255, 96, 78, 44);
  static const Color gradientBase = Color.fromARGB(255, 124, 116, 99);
  static const Color gradientAccent = Color.fromARGB(255, 245, 168, 14);
  static const Color green = Color.fromARGB(255, 59, 178, 115);
  static const Color red = Color.fromARGB(255, 230, 38, 38);

  static const LinearGradient mainGradient = LinearGradient(colors: [gradientBase,gradientAccent], begin: Alignment.bottomLeft, end: AlignmentDirectional(8, -8));

  static Color getInvertedButtonBackground(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return ThemeRaclette.invertedButtonBackground;
    }
    return ThemeRaclette.invertedButtonBackground;
  }

  static TextStyle invertedButtonTextStyle = const TextStyle(
      color: ThemeRaclette.primaryStatic,
    fontSize: 24
  );

  static var invertedButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith(ThemeRaclette.getInvertedButtonBackground),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
        )
    )
  );

  static Color getButtonBackground(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return ThemeRaclette.primaryStatic;
    }
    return ThemeRaclette.primaryStatic;
  }

  static TextStyle buttonTextStyle = const TextStyle(
      color: ThemeRaclette.black
  );

  static var buttonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith(ThemeRaclette.getButtonBackground),
  );


}
