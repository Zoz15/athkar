import 'package:flutter/material.dart';

class MosquePainter extends CustomPainter {
  final double progress;
  final bool isTop;
  final Color color;

  MosquePainter({
    required this.progress,
    required this.isTop,
    this.color = Colors.teal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    if (isTop) {
      // رسم النصف العلوي من المسجد
      // القبة الرئيسية
      path.moveTo(size.width * 0.3, size.height);
      path.quadraticBezierTo(
        size.width * 0.5, 
        size.height * 0.3,
        size.width * 0.7, 
        size.height
      );

      // المئذنة اليمنى
      path.moveTo(size.width * 0.8, size.height);
      path.lineTo(size.width * 0.8, size.height * 0.4);
      path.lineTo(size.width * 0.85, size.height * 0.3);
      path.lineTo(size.width * 0.8, size.height * 0.4);

      // المئذنة اليسرى
      path.moveTo(size.width * 0.2, size.height);
      path.lineTo(size.width * 0.2, size.height * 0.4);
      path.lineTo(size.width * 0.15, size.height * 0.3);
      path.lineTo(size.width * 0.2, size.height * 0.4);

    } else {
      // رسم النصف السفلي من المسجد
      // الجدار الرئيسي
      path.moveTo(size.width * 0.1, 0);
      path.lineTo(size.width * 0.1, size.height * 0.7);
      path.lineTo(size.width * 0.9, size.height * 0.7);
      path.lineTo(size.width * 0.9, 0);

      // الباب
      path.moveTo(size.width * 0.4, 0);
      path.lineTo(size.width * 0.4, size.height * 0.5);
      path.lineTo(size.width * 0.6, size.height * 0.5);
      path.lineTo(size.width * 0.6, 0);

      // النوافذ
      path.moveTo(size.width * 0.2, size.height * 0.3);
      path.lineTo(size.width * 0.3, size.height * 0.3);
      path.moveTo(size.width * 0.7, size.height * 0.3);
      path.lineTo(size.width * 0.8, size.height * 0.3);
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
  bool shouldRepaint(MosquePainter oldDelegate) =>
      progress != oldDelegate.progress || isTop != oldDelegate.isTop;
}
