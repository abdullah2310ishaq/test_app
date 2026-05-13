import 'package:flutter/material.dart';

/// Shared geometry for [HydrationGaugePainter] and the hydration card label column.
abstract final class HydrationGaugeLayout {
  HydrationGaugeLayout._();

  static const double tickTopFraction = 0.12;
  static const double tickBottomFraction = 0.78;

  static double tickTopY(double height) => height * tickTopFraction;

  static double tickBottomY(double height) => height * tickBottomFraction;

  /// Y of the middle key tick (same index as painter: `_tickCount ~/ 2`).
  static double tickMidKeyY(double height) {
    final top = tickTopY(height);
    final bottom = tickBottomY(height);
    return top + (bottom - top) * 0.5;
  }

  /// Y of the bottom key tick (last dash on the scale).
  static double tickBottomKeyY(double height) => tickBottomY(height);

  /// Centers a line/text block of [itemHeight] on [y].
  static double alignCenterOnTick(double y, double itemHeight) =>
      y - itemHeight / 2;
}

/// Vertical dashed water scale (2 L → 0 L) for the hydration card.
class HydrationGaugePainter extends CustomPainter {
  HydrationGaugePainter({
    required this.progress,
    required this.activeBlue,
    required this.inactiveDash,
  });

  /// 0.0 = empty, 1.0 = full (2 L).
  final double progress;
  final Color activeBlue;
  final Color inactiveDash;

  static const int _tickCount = 11;

  @override
  void paint(Canvas canvas, Size size) {
    final spineX = size.width * 0.5;
    final top = size.height * HydrationGaugeLayout.tickTopFraction;
    final bottom = size.height * HydrationGaugeLayout.tickBottomFraction;
    final span = bottom - top;

    final spinePaint = Paint()
      ..color = inactiveDash.withValues(alpha: 0.45)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(spineX, top), Offset(spineX, bottom), spinePaint);

    for (var i = 0; i < _tickCount; i++) {
      final t = i / (_tickCount - 1);
      final y = top + span * t;
      final fromBottom = 1.0 - t;
      final isKey = i == 0 || i == (_tickCount ~/ 2) || i == _tickCount - 1;
      final isWet = fromBottom <= progress + 0.0001;
      final useActive = isKey || isWet;
      final tickW = useActive ? size.width * 0.92 : size.width * 0.58;
      final fill = Paint()..color = useActive ? activeBlue : inactiveDash;
      final rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(spineX, y), width: tickW, height: 3),
        const Radius.circular(2),
      );
      canvas.drawRRect(rrect, fill);
    }
  }

  @override
  bool shouldRepaint(covariant HydrationGaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeBlue != activeBlue ||
        oldDelegate.inactiveDash != inactiveDash;
  }
}
