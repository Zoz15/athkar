import 'dart:ui';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:athkar/models/dhikr_item.dart';
import 'package:athkar/var.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:athkar/presentation/controllers/dhikr_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImages[0]),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              child: Column(
                children: [
                  _buildHeader(),
                  _buildDhikrSelector(),
                  const Spacer(),
                  _buildCounter(),
                  const Spacer(),
                  _buildTargetControl(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tasbeeh Counter',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              DateFormat('dd.MM.yyyy').format(DateTime.now()),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDhikrSelector() {
    final controller = Get.find<AppController>();
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Obx(() => Text(
                          controller.selectedDhikr.value?.text ?? 'اختر الذكر',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () => _showAddDhikrDialog(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        onPressed: () => _showDhikrList(),
                      ),
                    ],
                  ),
                ],
              ),
              Obx(
                () => controller.selectedDhikr.value != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedFlipCounter(
                              value: controller.clickerCounter.value,
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' / ${controller.selectedDhikr.value!.target}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddDhikrDialog() {
    final TextEditingController textController = TextEditingController();
    final TextEditingController targetController = TextEditingController();

    Get.dialog(
      SingleChildScrollView(
        child: AlertDialog(
          title: const Text('إضافة ذكر جديد'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(labelText: 'الذكر'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: targetController,
                decoration: const InputDecoration(labelText: 'العدد المستهدف'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.isNotEmpty &&
                    targetController.text.isNotEmpty) {
                  final controller = Get.find<AppController>();
                  controller.addDhikr(
                    DhikrItem(
                      text: textController.text,
                      target: int.parse(targetController.text),
                    ),
                  );
                  Get.back();
                }
              },
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDhikrList() {
    final controller = Get.find<AppController>();
    Get.dialog(
      AlertDialog(
        title: const Text('قائمة الأذكار'),
        content: SingleChildScrollView(
          child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: controller.dhikrList.asMap().entries.map((entry) {
                  final dhikr = entry.value;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: ListTile(
                      title: Text(
                        dhikr.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: LinearProgressIndicator(
                        value:
                            dhikr.target > 0 ? dhikr.current / dhikr.target : 0,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${dhikr.current}/${dhikr.target}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.removeDhikr(entry.key),
                          ),
                        ],
                      ),
                      onTap: () {
                        controller.selectDhikr(dhikr);
                        Get.back();
                      },
                    ),
                  );
                }).toList(),
              )),
        ),
      ),
    );
  }

  void _showCelebration() {
    final confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    confettiController.play();

    Get.dialog(
      Stack(
        children: [
          ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 50,
            gravity: 0.1,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
          AlertDialog(
            title: const Text('مبروك!'),
            content: const Text('لقد أكملت الذكر'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('حسناً'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounter() {
    final controller = Get.find<AppController>();
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/clicker/1.png', // todo: change to dynamic image
          width: 250,
          height: 250,
        ),
        Obx(() => Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Text(
                '${controller.clickerCounter.value}',
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        // Positioned(
        //   bottom: 20,
        //   child: InkWell(
        //     onTap: () => controller.setClickerCounter(),
        //     child: Container(
        //       padding: const EdgeInsets.symmetric(
        //         horizontal: 30,
        //         vertical: 10,
        //       ),
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: BorderRadius.circular(25),
        //       ),
        //       child: const Text(
        //         'Click',
        //         style: TextStyle(
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildTargetControl() {
    final controller = Get.find<AppController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 10),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white.withOpacity(0.1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    controller.setClickerImageIndex();
                  },
                  child: Image.asset(
                    'assets/images/colors.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 10),
            child: Container(
                height: height / 1.95,
                width: width - 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.1),
                ),
                child: Stack(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 10),
                    //   child: Align(
                    //     alignment: Alignment.bottomCenter,
                    //     child: Obx(
                    //       () => Row(
                    //         crossAxisAlignment: CrossAxisAlignment.end,
                    //         children: controller.chickImages.toList(),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Obx(
                      () => Column(
                        children: [
                          Image.asset(
                            clickerImages[controller.clickerImageIndex.value],
                            height: height / 2.2,
                            fit: BoxFit.cover,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: controller.chickImages.toList(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height / 8.9),
                      child: Center(
                          child: Column(
                        children: [
                          Obx(() => AnimatedFlipCounter(
                                value: controller.clickerCounter.value,
                                curve: Curves.easeInOut,
                                duration: const Duration(milliseconds: 200),
                                textStyle: const TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -1.0,
                                  color: Colors.white,
                                ),
                              )),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              //SystemSound.play(SystemSoundType.click);
                              controller.setClickerCounter();
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                //color: Colors.white.withOpacity(0.5),
                                //borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )
                        ],
                      )),
                    ),
                  ],
                )),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 10),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white.withOpacity(0.1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    controller.clickerCounterReset();
                  },
                  child: Image.asset(
                    'assets/images/replay.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
