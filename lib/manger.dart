import 'package:athkar/var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Manger extends GetxController {
  RxInt customNumber = 70.obs;

  void setCustomNumber(int value) {
    print('value: $value');
    customNumber.value = value;
  }

  RxInt selectedNumber = numbers[0].obs;
  RxDouble hightOfContainer = 60.0.obs;
  RxDouble widthOfContainer = 70.0.obs;

  void setSelectedNumber(int value) {
    print('value2: $value');

    if (value == numbers[0] || value == numbers[1] || value == numbers[2]) {
      hightOfContainer.value = 60;
      widthOfContainer.value = 70;
      selectedNumber.value = value;
    } else {
      // clickerCounterReset();
      print('got here');
      hightOfContainer.value = 60;
      widthOfContainer.value = width - 90;
      selectedNumber.value = customNumber.value;
    }
    ifYouPlus();
  }

  void ifYouPlus() {
    if (clickerCounter.value > selectedNumber.value - 1) {
      clickerCounter.value = 0;
      if (chickImages.length < 5) {
        chickImages.add(chickImage as Image);
      }
    }
  }

  RxInt clickerImageIndex = 0.obs;

  void setClickerImageIndex() {
    clickerImageIndex.value = clickerImageIndex.value + 1;
    if (clickerImageIndex.value == clickerImages.length) {
      clickerImageIndex.value = 0;
    }
  }

  RxInt clickerCounter = 0.obs;
  RxList<Image> chickImages = <Image>[].obs;

  void clickerCounterReset() {
    clickerCounter.value = 0;
    chickImages.clear();
  }

  void setClickerCounter() {
    if (clickerCounter.value > selectedNumber.value - 1) {
      clickerCounter.value = 1;
      if (chickImages.length < 5) {
        chickImages.add(chickImage as Image);
      }
      print(chickImages.length);
    } else {
      clickerCounter.value = clickerCounter.value + 1;
    }
  }
}
