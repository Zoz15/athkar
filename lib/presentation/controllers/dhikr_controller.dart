import 'package:athkar/var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:athkar/data/datasources/local_storage.dart';
import 'package:athkar/models/dhikr_item.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' show Random, pi;

class AppController extends GetxController {
  final _storage = Get.find<LocalStorage>();
  final confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  final dhikrList = <DhikrItem>[].obs;
  final selectedDhikr = Rxn<DhikrItem>();
  final clickerCounter = 0.obs;
  final clickerImageIndex = 0.obs;

  // إضافة متغير للخلفية الحالية
  final currentBackground = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // تغيير الخلفية عشوائياً عند بدء التطبيق
    changeBackground();
    loadDhikrs();
  }

  // دالة لتغيير الخلفية عشوائياً
  void changeBackground() {
    final random = Random();
    int newIndex;
    do {
      newIndex = random.nextInt(backgroundImages.length);
    } while (newIndex == currentBackground.value && backgroundImages.length > 1);
    currentBackground.value = newIndex;
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
    if (clickerImageIndex.value < clickerImages.length - 1) {
      clickerImageIndex.value++;
    } else {
      clickerImageIndex.value = 0;
    }
  }

  void setClickerCounter() {
    if (selectedDhikr.value == null) {
      final uncompletedDhikr =
          dhikrList.firstWhereOrNull((dhikr) => dhikr.current < dhikr.target);

      if (uncompletedDhikr != null) {
        selectDhikr(uncompletedDhikr);
        return;
      } else {
        Get.snackbar(
          'تنبيه',
          'الرجاء إضافة ذكر جديد',
          backgroundColor: Colors.white.withOpacity(0.1),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        );
        return;
      }
    }

    if (selectedDhikr.value!.current >= selectedDhikr.value!.target) {
      final nextDhikr = dhikrList.firstWhereOrNull((dhikr) =>
          dhikr.current < dhikr.target && dhikr != selectedDhikr.value);

      if (nextDhikr != null) {
        selectDhikr(nextDhikr);
        return;
      }
    }

    if (clickerCounter.value < selectedDhikr.value!.target) {
      clickerCounter.value++;
      selectedDhikr.value!.current = clickerCounter.value;
      selectedDhikr.value!.lastUpdated = DateTime.now();

      _storage.saveDhikrs(dhikrList);

      if (clickerCounter.value == selectedDhikr.value!.target) {
        _showCelebration();
      }
    }
  }

  void clickerCounterReset() {
    if (selectedDhikr.value != null) {
      Get.dialog(
        AlertDialog(
          title: const Text('تأكيد إعادة التعيين'),
          content: const Text('هل أنت متأكد من إعادة تعيين العداد؟'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                clickerCounter.value = 0;
                selectedDhikr.value!.current = 0;
                _storage.saveDhikrs(dhikrList);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('إعادة تعيين'),
            ),
          ],
        ),
      );
    }
  }

  void selectDhikr(DhikrItem dhikr) {
    selectedDhikr.value = dhikr;
    clickerCounter.value = dhikr.current;
    update();
  }

  void _showCelebration() {
    confettiController.play();
    Get.dialog(
      Stack(
        alignment: Alignment.center,
        children: [
          // قصاصات من اليسار
          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: pi/2,
              blastDirectionality: BlastDirectionality.directional,
              emissionFrequency: 0.3,
              numberOfParticles: 10,
              gravity: 0.5,
              minimumSize: const Size(10, 10),
              maximumSize: const Size(15, 15),
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.red,
                Colors.yellow,
              ],
            ),
          ),
          // قصاصات من الوسط
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: pi/2,
              blastDirectionality: BlastDirectionality.directional,
              emissionFrequency: 0.3,
              numberOfParticles: 10,
              gravity: 0.5,
              minimumSize: const Size(10, 10),
              maximumSize: const Size(15, 15),
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.red,
                Colors.yellow,
              ],
            ),
          ),
          // قصاصات من اليمين
          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: pi/2,
              blastDirectionality: BlastDirectionality.directional,
              emissionFrequency: 0.3,
              numberOfParticles: 10,
              gravity: 0.5,
              minimumSize: const Size(10, 10),
              maximumSize: const Size(15, 15),
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.red,
                Colors.yellow,
              ],
            ),
          ),
          // قصاصات من اليسار الأوسط
          Align(
            alignment: const Alignment(-0.5, -1),
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: pi/2,
              blastDirectionality: BlastDirectionality.directional,
              emissionFrequency: 0.3,
              numberOfParticles: 10,
              gravity: 0.5,
              minimumSize: const Size(10, 10),
              maximumSize: const Size(15, 15),
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.red,
                Colors.yellow,
              ],
            ),
          ),
          // قصاصات من اليمين الأوسط
          Align(
            alignment: const Alignment(0.5, -1),
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: pi/2,
              blastDirectionality: BlastDirectionality.directional,
              emissionFrequency: 0.3,
              numberOfParticles: 10,
              gravity: 0.5,
              minimumSize: const Size(10, 10),
              maximumSize: const Size(15, 15),
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.red,
                Colors.yellow,
              ],
            ),
          ),
          AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text(
              'مبروك!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'لقد أكملت الذكر',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'حسناً',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void addDhikr(DhikrItem dhikr) {
    dhikrList.add(dhikr);
    _storage.saveDhikrs(dhikrList);
  }

  void removeDhikr(int index) {
    if (selectedDhikr.value == dhikrList[index]) {
      selectedDhikr.value = null;
      clickerCounter.value = 0;
    }
    dhikrList.removeAt(index);
    _storage.saveDhikrs(dhikrList);
  }

  void confirmRemoveDhikr(int index) {
    Get.dialog(
      AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا الذكر؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              removeDhikr(index);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void confirmReset() {
    if (selectedDhikr.value == null) return;
    
    Get.dialog(
      AlertDialog(
        title: const Text('تأكيد إعادة التعيين'),
        content: const Text('هل أنت متأكد من إعادة تعيين العداد؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              clickerCounterReset();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('إعادة تعيين'),
          ),
        ],
      ),
    );
  }
}
