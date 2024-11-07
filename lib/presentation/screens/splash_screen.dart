import 'dart:math';

import 'package:athkar/presentation/widgets/tasbeeh_painter.dart';
import 'package:athkar/var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:athkar/presentation/screens/home_screen.dart';
import 'package:athkar/presentation/widgets/mosque_painter.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _drawAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _splitAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _drawAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.3, curve: Curves.easeInOut),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
      ),
    );

    _splitAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1, curve: Curves.easeInOut),
      ),
    );

    _controller.forward().then((_) {
      Get.off(() => const HomeScreen(), transition: Transition.fade);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // خلفية متدرجة ذهبي وأسود
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFF1A1A1A), // أسود داكن
                      Color(0xFFD4AF37), // ذهبي
                    ],
                    stops: [0.3, 0.9],
                  ),
                ),
              ),
              // السبحة المرسومة
              Center(
                child: SizedBox(
                  width: 300,
                  height: 400, // زيادة الارتفاع للسماح بالشرابة
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // النصف العلوي
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..rotateZ(_rotationAnimation.value)
                          ..translate(0.0, -100 * _splitAnimation.value),
                        child: CustomPaint(
                          size: const Size(300, 200),
                          painter: TasbeehPainter(
                            progress: _drawAnimation.value,
                            isTop: true,
                          ),
                        ),
                      ),
                      // النصف السفلي
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..rotateZ(_rotationAnimation.value)
                          ..translate(0.0, 100 * _splitAnimation.value),
                        child: CustomPaint(
                          size: const Size(300, 200),
                          painter: TasbeehPainter(
                            progress: _drawAnimation.value,
                            isTop: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
