import 'package:get/get.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'de_DE': {
          'greeting': 'Hallo',
        },
        'en_US': {
          'greeting': 'Hello',
        },
      };
}