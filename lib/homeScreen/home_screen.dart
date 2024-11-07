import 'dart:math';
import 'dart:ui';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:athkar/manger.dart';
import 'package:athkar/var.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _maxBackgroundImages = backgroundImages.length;
  late final String _backgroundImageIndex;

  @override
  void initState() {
    super.initState();
    _backgroundImageIndex =
        backgroundImages[Random().nextInt(_maxBackgroundImages)];
  }

  @override
  Widget build(BuildContext context) {
    final manger = Get.put(Manger());
    return Scaffold(
      body: _buildBackgroundContainer(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTitle(),
              _buildClicker(),
              // const Spacer(),
              _buildBottomCounter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClicker() {
    final manger = Get.find<Manger>();
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
                    manger.setClickerImageIndex();
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
                    //         children: manger.chickImages.toList(),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Obx(
                      () => Column(
                        children: [
                          Image.asset(
                            clickerImages[manger.clickerImageIndex.value],
                            height: height / 2.2,
                            fit: BoxFit.cover,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: manger.chickImages.toList(),
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
                                value: manger.clickerCounter.value,
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
                              manger.setClickerCounter();
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
                    manger.clickerCounterReset();
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

  Widget _buildBackgroundContainer({required Widget child}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_backgroundImageIndex),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }

  Widget _buildTitle() {
    return Text(
      'التسبيح',
      style: GoogleFonts.aboreto(
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildBottomCounter() {
    final manger = Get.find<Manger>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 170,
            width: width - 90,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
                  child: Obx(
                    () => AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      alignment: _alignContainer(manger),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Obx(
                            () => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: manger.hightOfContainer.value,
                              width: manger.widthOfContainer.value,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withOpacity(0.15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCounterButton(numbers[0]),
                          _buildCounterButton(numbers[1]),
                          _buildCounterButton(numbers[2]),
                        ],
                      ),
                      _buildCustomNumberInput(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCounterButton(int number) {
    final manger = Get.find<Manger>();
    return InkWell(
      onTap: () {
        manger.setSelectedNumber(number);
        manger.chickImages.clear();
      },
      child: Center(
        child: SizedBox(
          height: 60,
          width: 60,
          child: Text(
            "$number",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomNumberInput() {
    final manger = Get.find<Manger>();

    return InkWell(
      onTap: () {
        manger.setSelectedNumber(-1);
      },
      child: Center(
        child: Obx(() => NumberPicker(
              value: manger.customNumber.value,
              axis: Axis.horizontal,
              decoration: BoxDecoration(
                border: Border.all(
                    color: manger.selectedNumber.value != '33' &&
                            manger.selectedNumber.value != '55' &&
                            manger.selectedNumber.value != '99'
                        ? Colors.blue
                        : Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              minValue: 10,
              maxValue: 200,
              step: 2,
              itemCount: 5,
              itemWidth: 50,
              onChanged: (value) {
                manger.setCustomNumber(value);
                manger.setSelectedNumber(-1);
              },
              haptics: true,
              textStyle: const TextStyle(
                fontSize: 15,
                color: Colors.white60,
              ),
              selectedTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )),
      ),
    );
  }
}

Alignment _alignContainer(Manger manger) {
  return manger.selectedNumber.value == numbers[0]
      ? Alignment.topLeft
      : manger.selectedNumber.value == numbers[1]
          ? Alignment.topCenter
          : manger.selectedNumber.value == numbers[2]
              ? Alignment.topRight
              : Alignment.bottomCenter;
}
