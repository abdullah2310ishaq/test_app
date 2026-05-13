import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Sweep-gradient ring plus twelve faint radial ticks (no ring blur).
class MoodRingBackgroundPainter extends CustomPainter {
  MoodRingBackgroundPainter({required this.ringStrokeWidth});

  final double ringStrokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.shortestSide / 2 - ringStrokeWidth * 0.35;

    final shaderRect = Rect.fromCircle(
      center: center,
      radius: r + ringStrokeWidth,
    );
    final sweep = SweepGradient(
      center: Alignment.center,
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
      tileMode: TileMode.clamp,
      colors: const [
        AppColors.moodRingTeal,
        AppColors.moodRingPurple,
        AppColors.moodRingPink,
        AppColors.moodRingOrange,
        AppColors.moodRingTeal,
      ],
      stops: const [0, 0.25, 0.5, 0.75, 1],
    );

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringStrokeWidth
      ..shader = sweep.createShader(shaderRect);

    canvas.drawCircle(center, r, ringPaint);

    final tickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.14);

    final inner = r - ringStrokeWidth * 0.55;
    final outer = r + ringStrokeWidth * 0.55;
    for (var i = 0; i < 12; i++) {
      final ang = i * math.pi / 6;
      final sin = math.sin(ang);
      final cos = math.cos(ang);
      canvas.drawLine(
        Offset(center.dx + inner * sin, center.dy - inner * cos),
        Offset(center.dx + outer * sin, center.dy - outer * cos),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant MoodRingBackgroundPainter oldDelegate) {
    return oldDelegate.ringStrokeWidth != ringStrokeWidth;
  }
}
