import 'dart:math';

import 'package:flutter/material.dart';

class TasbeehPainter extends CustomPainter {
  final double progress;
  final bool isTop;

  TasbeehPainter({required this.progress, required this.isTop});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final beadPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    if (isTop) {
      // رسم النصف العلوي من السبحة
      final center = Offset(size.width * 0.5, size.height * 0.5);
      final radius = size.width * 0.35;
      
      // رسم الخيط الرئيسي (دائري كامل)
      path.addArc(
        Rect.fromCenter(
          center: center,
          width: radius * 2,
          height: radius * 2,
        ),
        0,    // نبدأ من 0
        pi * 2, // نرسم دائرة كاملة (2π)
      );

      // رسم الخيط المتدلي
      path.moveTo(size.width * 0.5, size.height);
      path.lineTo(size.width * 0.5, size.height * 0.85);
      
      // رسم حبات السبحة في دائرة كاملة
      final beadCount = 33; // عدد الحبات
      final beadRadius = 8.0; // حجم الحبة
      
      for (var i = 0; i < beadCount; i++) {
        final angle = (2 * pi * i) / beadCount; // توزيع الحبات على الدائرة الكاملة
        final beadCenter = Offset(
          center.dx + cos(angle) * radius,
          center.dy + sin(angle) * radius,
        );
        
        // رسم الحبة مع ظل
        canvas.drawCircle(beadCenter, beadRadius, beadPaint);
        canvas.drawCircle(beadCenter, beadRadius, paint);
        
        // رسم الخط الرابط بين الحبات
        if (i < beadCount) {
          final nextAngle = (2 * pi * (i + 1)) / beadCount;
          final nextCenter = Offset(
            center.dx + cos(nextAngle) * radius,
            center.dy + sin(nextAngle) * radius,
          );
          
          // رسم خط رفيع بين الحبات
          canvas.drawLine(
            beadCenter,
            nextCenter,
            paint..strokeWidth = 1,
          );
        }
      }
      
    } else {
      // رسم النصف السفلي من السبحة (الشرابة)
      path.moveTo(size.width * 0.5, 0);
      
      // خيوط متموجة متعددة
      for (var i = 0; i < 7; i++) {
        final startX = size.width * 0.5 + (i - 3) * 8;
        path.moveTo(size.width * 0.5, 0);
        
        // إنشاء منحنى متموج أطول
        path.cubicTo(
          startX, size.height * 0.3,
          startX + (i % 2 == 0 ? 15 : -15), size.height * 0.5,
          startX + (i - 3) * 12, size.height * 0.7,
        );
      }
      
      // إضافة حبات صغيرة على الشرابة
      for (var i = 0; i < 5; i++) {
        final beadCenter = Offset(
          size.width * 0.5 + (i - 2) * 12,
          size.height * 0.4 + (i % 2) * 20,
        );
        canvas.drawCircle(beadCenter, 4, beadPaint);
        canvas.drawCircle(beadCenter, 4, paint);
      }
    }

    // رسم المسار مع تأثير التقدم
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      final extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * progress,
      );
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(TasbeehPainter oldDelegate) =>
      progress != oldDelegate.progress || isTop != oldDelegate.isTop;
} 