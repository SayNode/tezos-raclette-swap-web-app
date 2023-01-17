import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;
  RxInt pos = Random().nextInt(13).obs;
  late Timer timer;

  @override
  void onInit() {
    timer = Timer.periodic(const Duration(seconds: 30), (Timer t) {
      pos.value = (pos.value + 1) % 5;
    });
    super.onInit();
  }


}
