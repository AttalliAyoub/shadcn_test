import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'progress_border.dart';
export 'progress_border.dart';

class AnimatedBorder extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final ProgressBorder shape;
  final TextDirection? textDirection;

  const AnimatedBorder({
    super.key,
    this.textDirection,
    required this.child,
    this.duration = const Duration(seconds: 1),
    required this.shape,
  });

  @override
  State<AnimatedBorder> createState() => AnimatedBorderState();
}

class AnimatedBorderState extends State<AnimatedBorder>
    with SingleTickerProviderStateMixin {
  ProgressBorder get shape => widget.shape;
  late ProgressBorder oldShape = shape;
  late bool animateDash = shape.dashLength != null;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: shape.progress,
    );
    _controller.animateTo(shape.progress);
    if (shape.dashLength != null) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    _didUpdateWidget(oldWidget);
  }

  void _didUpdateWidget(AnimatedBorder oldWidget) async {
    // 1. Handle Duration changes
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    // 2. Handle Shape changes (e.g. going from static to dashing)
    if (widget.shape.dashLength != oldWidget.shape.dashLength) {
      if (widget.shape.dashLength != null) {
        _controller.value = widget.shape.progress;
        _controller.repeat();
      } else {
        // _controller.animateTo(widget.shape.progress);
        _controller.stop();
        _controller.value = widget.shape.progress;
      }
    }

    // 3. Handle Progress changes from outside (if not animating)
    if (widget.shape.progress != oldWidget.shape.progress &&
        widget.shape.dashLength == null) {
      _controller.animateTo(widget.shape.progress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = widget.textDirection ?? Directionality.of(context);
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      child: RepaintBoundary(child: widget.child),
      builder: (context, child) {
        final value = _controller.value;
        return CustomPaint(
          painter: ProgressBorderPainter(
            shape: shape.copyWith(progress: value),
            textDirection: textDirection,
          ),
          child: child,
        );
      },
    );
  }
}

class ProgressBorderPainter extends CustomPainter {
  final ProgressBorder shape;
  final TextDirection textDirection;

  const ProgressBorderPainter({
    required this.shape,
    required this.textDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    shape.paint(canvas, rect, textDirection: textDirection);
  }

  @override
  bool shouldRepaint(covariant ProgressBorderPainter oldDelegate) =>
      oldDelegate.shape != shape || oldDelegate.textDirection != textDirection;
}

typedef AnimatedBorderBuilder<T extends Widget> =
    Widget Function(
      BuildContext context,
      ProgressBorder shape,
      T child,
    );

extension AnimatedBorderExt<T extends Widget> on T {
  AnimatedBorder animatedBorder(
    BuildContext context, {
    final Duration duration = const Duration(seconds: 1),
    ProgressBorder? shape,
    final TextDirection? textDirection,
    final AnimatedBorderBuilder<T>? builder,
  }) {
    shape ??= ProgressBorder.fromContext(context);
    return AnimatedBorder(
      shape: shape,
      textDirection: textDirection,
      duration: duration,
      key: key,
      child: builder?.call(context, shape, this) ?? this,
    );
  }
}

// class ProgressShapeDecoration extends ShapeDecoration {
//   const ProgressShapeDecoration({
//     super.color,
//     super.image,
//     super.gradient,
//     super.shadows,
//     ProgressBorder shape = const ProgressBorder(),
//   }) : super(shape: shape);

//   ProgressShapeDecoration copyWith({
//     ProgressBorder? shape,
//     Color? color,
//     DecorationImage? image,
//     Gradient? gradient,
//     List<BoxShadow>? shadows,
//     double? progress,
//   }) {
//     return ProgressShapeDecoration(
//       shape: shape ?? this.shape as ProgressBorder,
//       color: color ?? this.color,
//       image: image ?? this.image,
//       gradient: gradient ?? this.gradient,
//       shadows: shadows ?? this.shadows,
//     );
//   }

// }
