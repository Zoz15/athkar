import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:athkar/data/datasources/local_storage.dart';
import 'package:athkar/models/dhikr_item.dart';
import 'package:confetti/confetti.dart';

class AppController extends GetxController {
  final _storage = Get.find<LocalStorage>();
  final confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  final dhikrList = <DhikrItem>[].obs;
  final selectedDhikr = Rxn<DhikrItem>();
  final clickerCounter = 999.obs;
  final clickerImageIndex = 0.obs;
  final chickImages = <Widget>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDhikrs();
  }

  Future<void> loadDhikrs() async {
    final items = await _storage.getDhikrs();
    _resetExpiredDhikrs(items);
    dhikrList.value = items;
  }

  void _resetExpiredDhikrs(List<DhikrItem> items) {
    final now = DateTime.now();
    for (var dhikr in items) {
      if (dhikr.lastUpdated != null &&
          now.difference(dhikr.lastUpdated!).inDays >= 1) {
        dhikr.current = 0;
        dhikr.lastUpdated = null;
      }
    }
  }

  void setClickerImageIndex() {
    clickerImageIndex.value =
        (clickerImageIndex.value + 1) % chickImages.length;
  }

  void setClickerCounter() {
    if (selectedDhikr.value != null) {
      clickerCounter.value++;
      selectedDhikr.value!.current = clickerCounter.value;
      selectedDhikr.value!.lastUpdated = DateTime.now();

      if (clickerCounter.value == selectedDhikr.value!.target) {
        _showCelebration();
      }

      _storage.saveDhikrs(dhikrList);
    }
  }

  void clickerCounterReset() {
    if (selectedDhikr.value != null) {
      clickerCounter.value = 0;
      selectedDhikr.value!.current = 0;
      _storage.saveDhikrs(dhikrList);
    }
  }

  void selectDhikr(DhikrItem dhikr) {
    selectedDhikr.value = dhikr;
    clickerCounter.value = dhikr.current;
  }

  void _showCelebration() {
    confettiController.play();
  }

  void addDhikr(DhikrItem dhikr) {
    dhikrList.add(dhikr);
    _storage.saveDhikrs(dhikrList);
  }

  void removeDhikr(int index) {
    // If the removed dhikr was selected, clear the selection
    if (selectedDhikr.value == dhikrList[index]) {
      selectedDhikr.value = null;
      clickerCounter.value = 0;
    }

    dhikrList.removeAt(index);
    _storage.saveDhikrs(dhikrList);
  }
}
