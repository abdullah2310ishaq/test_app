import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/mood_kind.dart';
import '../painters/mood_ring_painter.dart';
import '../providers/mood_selection_notifier.dart';

/// Interactive mood wheel: sweep ring, thumb on a fixed orbit, center asset.
class MoodRingSelector extends StatelessWidget {
  const MoodRingSelector({super.key});

  static double _trackRadius(double side, double stroke) {
    return side / 2 - stroke * 0.35;
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<MoodSelectionNotifier>();
    final stroke = 26.w;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxSide = math.min(constraints.maxWidth, constraints.maxHeight);
        final side = maxSide.clamp(168.w, 258.w);
        final center = Offset(side / 2, side / 2);
        final trackR = _trackRadius(side, stroke);
        final thumbOffset = Offset(
          center.dx + trackR * math.sin(notifier.angleRad),
          center.dy - trackR * math.cos(notifier.angleRad),
        );

        return SizedBox(
          width: side,
          height: side,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) =>
                notifier.updateFromLocalPointer(center, d.localPosition),
            onPanDown: (d) =>
                notifier.updateFromLocalPointer(center, d.localPosition),
            onPanUpdate: (d) =>
                notifier.updateFromLocalPointer(center, d.localPosition),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                RepaintBoundary(
                  child: CustomPaint(
                    size: Size(side, side),
                    painter: MoodRingBackgroundPainter(ringStrokeWidth: stroke),
                  ),
                ),
                _CenterMoodFace(mood: notifier.mood, box: side * 0.42),
                Positioned(
                  left: thumbOffset.dx - 16.w,
                  top: thumbOffset.dy - 16.w,
                  child: _MoodThumb(diameter: 32.w),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MoodThumb extends StatelessWidget {
  const _MoodThumb({required this.diameter});

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.moodThumb,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.45),
            blurRadius: 18,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}

class _CenterMoodFace extends StatelessWidget {
  const _CenterMoodFace({required this.mood, required this.box});

  final MoodKind mood;
  final double box;

  @override
  Widget build(BuildContext context) {
    final radius = 22.r;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: Container(
        key: ValueKey<MoodKind>(mood),
        width: box,
        height: box,
        decoration: BoxDecoration(
          color: AppColors.moodCenterCard,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Image.asset(
            mood.assetPath,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              Icons.sentiment_satisfied_alt_rounded,
              size: 40.sp,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
