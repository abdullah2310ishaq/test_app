import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../domain/mood_kind.dart';

class MoodSelectionNotifier extends ChangeNotifier {
  double _angleRad = 3 * math.pi / 4;

  double get angleRad => _angleRad;

  MoodKind get mood => moodFromAngleRad(_angleRad);

  /// Clockwise-from-top polar angle for vector `(dx, dy)` relative to ring center.
  static double angleClockwiseFromTopRad(double dx, double dy) {
    final atan = math.atan2(dx, -dy);
    return atan < 0 ? atan + 2 * math.pi : atan;
  }

  /// Spec: 0–90° Calm, 91–180° Content, 181–270° Peaceful, 271–360° Happy
  /// (implemented with inclusive degree bands on the circle).
  static MoodKind moodFromAngleRad(double angleRad) {
    final twoPi = 2 * math.pi;
    final a = angleRad % twoPi;
    final deg = a * 180 / math.pi;
    if (deg <= 90) {
      return MoodKind.calm;
    }
    if (deg <= 180) {
      return MoodKind.content;
    }
    if (deg <= 270) {
      return MoodKind.peaceful;
    }
    return MoodKind.happy;
  }

  void setAngleFromVector(double dx, double dy) {
    if (dx * dx + dy * dy < 4) {
      return;
    }
    final next = angleClockwiseFromTopRad(dx, dy);
    if ((next - _angleRad).abs() < 1e-9) {
      return;
    }
    _angleRad = next;
    notifyListeners();
  }

  void updateFromLocalPointer(Offset center, Offset local) {
    final dx = local.dx - center.dx;
    final dy = local.dy - center.dy;
    setAngleFromVector(dx, dy);
  }
}
