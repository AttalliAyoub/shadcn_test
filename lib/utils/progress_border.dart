import 'dart:ui' as ui;
import 'path.dart';
import 'package:flutter/foundation.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ProgressBorder extends RoundedRectangleBorder {
  final double progress;
  final double? dashLength;
  final StrokeCap strokeCap;
  final Color foregroundColor;
  // final TextDirection? textDirection;
  const ProgressBorder({
    this.progress = .0,
    this.dashLength,
    // this.textDirection,
    this.strokeCap = StrokeCap.round,
    this.foregroundColor = Colors.pink,
    super.side = const BorderSide(color: Colors.transparent, width: 2),
    super.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  factory ProgressBorder.fromContext(
    BuildContext context, {
    double progress = .0,
    double? dashLength,
    TextDirection? textDirection,
    StrokeCap strokeCap = StrokeCap.round,
    BorderSide side = const BorderSide(color: Colors.transparent, width: 2),
    BorderRadiusGeometry borderRadius = const BorderRadius.all(
      Radius.circular(16),
    ),
  }) {
    return ProgressBorder(
      borderRadius: borderRadius,
      dashLength: dashLength,
      progress: progress,
      side: side,
      strokeCap: strokeCap,
      foregroundColor: Theme.of(context).colorScheme.primary,
      // textDirection: textDirection,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return copyWith(side: side.scale(t), borderRadius: borderRadius * t);
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is ProgressBorder) {
      return ProgressBorder(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius: BorderRadiusGeometry.lerp(
          a.borderRadius,
          borderRadius,
          t,
        )!,
        progress: ui.lerpDouble(a.progress, progress, t)!,
        strokeCap: t < 0.5 ? a.strokeCap : strokeCap,
        dashLength: ui.lerpDouble(a.dashLength, dashLength, t),
        foregroundColor: Color.lerp(a.foregroundColor, foregroundColor, t)!,
        // textDirection: t < 0.5 ? a.textDirection : textDirection,
      );
    }
    // TODO: implement lerpFrom
    // if (a is CircleBorder) {
    //   return _RoundedRectangleToCircleBorder(
    //     side: BorderSide.lerp(a.side, side, t),
    //     borderRadius: borderRadius,
    //     circularity: 1.0 - t,
    //     eccentricity: a.eccentricity,
    //   );
    // }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is ProgressBorder) {
      return ProgressBorder(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius: BorderRadiusGeometry.lerp(
          borderRadius,
          b.borderRadius,
          t,
        )!,
        progress: ui.lerpDouble(progress, b.progress, t)!,
        strokeCap: t < 0.5 ? strokeCap : b.strokeCap,
        dashLength: ui.lerpDouble(dashLength, b.dashLength, t),
        foregroundColor: Color.lerp(foregroundColor, b.foregroundColor, t)!,
        // textDirection: t < 0.5 ? textDirection : b.textDirection,
      );
    }
    // TODO: implement lerpTo
    // if (b is CircleBorder) {
    //   return _RoundedRectangleToCircleBorder(
    //     side: BorderSide.lerp(side, b.side, t),
    //     borderRadius: borderRadius,
    //     circularity: t,
    //     eccentricity: b.eccentricity,
    //   );
    // }
    return super.lerpTo(b, t);
  }

  /// Returns a copy of this RoundedRectangleBorder with the given fields
  /// replaced with the new values.
  @override
  ProgressBorder copyWith({
    BorderSide? side,
    BorderRadiusGeometry? borderRadius,
    double? progress,
    StrokeCap? strokeCap,
    double? dashLength,
    Color? foregroundColor,
    TextDirection? textDirection,
  }) {
    return ProgressBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
      progress: progress ?? this.progress,
      strokeCap: strokeCap ?? this.strokeCap,
      dashLength: dashLength ?? this.dashLength,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      // textDirection: textDirection ?? this.textDirection,
    );
  }

  @override
  bool get preferPaintInterior => true;

  Path getPath(
    Rect rect, {
    TextDirection? textDirection,
    bool reverse = false,
  }) {
    final path = Path()
      ..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
    final totalLength = path.totalLength;
    if (dashLength != null) {
      final start = totalLength * progress;
      final end = totalLength * progress + dashLength! * totalLength;
      return path.getSubPath(reverse ? end : start, reverse ? start : end);
    }
    final end = totalLength * progress;
    return path.getSubPath(reverse ? end : 0, reverse ? 0 : end);
  }

  @override
  Path getInnerPath(
    Rect rect, {
    TextDirection? textDirection,
    bool reverse = false,
  }) {
    return getPath(
      rect.deflate(side.strokeInset),
      textDirection: textDirection,
      reverse: reverse,
    );
  }

  @override
  Path getOuterPath(
    Rect rect, {
    TextDirection? textDirection,
    bool reverse = false,
  }) {
    return getPath(rect, textDirection: textDirection, reverse: reverse);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (rect.isEmpty) return;
    if (side.style == BorderStyle.none) return;
    final paint = side.toPaint()..strokeCap = strokeCap;
    final path = getOuterPath(
      rect,
      textDirection: textDirection,
      reverse: false,
    );
    canvas.drawPath(path, paint);
    paint.color = foregroundColor;
    canvas.drawPath(
      getOuterPath(rect, textDirection: textDirection),
      paint,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ProgressBorder &&
        other.side == side &&
        other.borderRadius == borderRadius &&
        other.progress == progress &&
        other.strokeCap == strokeCap &&
        other.dashLength == dashLength &&
        other.foregroundColor == foregroundColor;
  }

  @override
  int get hashCode => Object.hash(
    side,
    borderRadius,
    progress,
    strokeCap,
    dashLength,
    foregroundColor,
  );

  @override
  String toString() {
    return '${objectRuntimeType(this, 'ProgressBorder')}($side, $borderRadius, $progress, $strokeCap, $dashLength, $foregroundColor)';
  }
}
