import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    required this.animation,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 12.0
      ..style = PaintingStyle.stroke;

    final progress = animation.value;

    Path path = createPath(size);
    ui.PathMetric pathMetric = path.computeMetrics().first;
    const start = 0.0;
    final end = (pathMetric.length - (pathMetric.length * progress));
    Path extractPath = pathMetric.extractPath(start, end);
    canvas.drawPath(extractPath, paint);
  }

  Path createPath(Size size) {
    Path path = Path();
    final W = size.width;
    final H = size.height;
    path.moveTo(W / 2, 0);
    path.lineTo(0, 0);
    path.lineTo(0, H);
    path.lineTo(W, H);
    path.lineTo(W, 0);
    path.lineTo(W / 2, 0);
    return path;
  }

  @override
  bool shouldRepaint(CustomTimerPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        color != oldDelegate.color;
  }
}
