import 'dart:async';
import 'package:get/get.dart';

class ImageLoopController extends GetxController {
  RxInt currentImageIndex = 0.obs;
  List<String> images = [
    'assets/img_30.png',
    'assets/img_31.png',
    'assets/img_32.png',
  ];
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    startImageLoop();
  }

  @override
  void onClose() {
    stopImageLoop();
    super.onClose();
  }

  void startImageLoop() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      currentImageIndex.value = (currentImageIndex.value + 1) % images.length;
    });
  }

  void stopImageLoop() {
    timer?.cancel();
  }
}