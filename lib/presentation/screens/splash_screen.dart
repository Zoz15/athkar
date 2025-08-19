import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:athkar/presentation/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // التوجيه للشاشة الرئيسية بعد ثانيتين
    Future.delayed(const Duration(seconds: 2), () {
      Get.off(() => const HomeScreen());
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: [
            // صورة الأيقونة
            Center(
              child: Image.asset(
                'assets/splash screen/icon_w.png',
                width: 180,
                height: 180,
              ),
            ),
            // صورة النص
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 10),
                child: Image.asset(
                  'assets/splash screen/start.png',
                  width: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
