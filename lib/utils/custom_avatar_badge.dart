import 'package:shadcn_flutter/shadcn_flutter.dart';

class CustomAvatarBadge extends StatelessWidget implements AvatarWidget {
  /// Size of the badge in logical pixels.
  ///
  /// Controls both width and height of the circular badge container.
  /// If null, defaults to theme.scaling * 12.
  @override
  final double? size;

  final double? height;

  /// Border radius for the badge corners in logical pixels.
  ///
  /// If null, defaults to theme.radius * size for proportional rounding,
  /// typically creating a circular badge.
  @override
  final double? borderRadius;

  /// Optional child widget to display inside the badge.
  ///
  /// Can be an icon, text, or other widget. If null, displays as a
  /// solid colored circle using [color].
  final Widget? child;

  /// Background color of the badge.
  ///
  /// If null, defaults to the theme's primary color. Used as the
  /// background color for the circular container.
  final Color? color;

  /// Creates an [CustomAvatarBadge].
  ///
  /// The badge can display either custom content via [child] or function
  /// as a simple colored indicator.
  ///
  /// Parameters:
  /// - [child] (Widget?, optional): Content to display inside the badge.
  ///   If null, shows as a solid colored circle.
  /// - [size] (double?, optional): Badge dimensions in logical pixels.
  ///   Defaults to theme.scaling * 12.
  /// - [borderRadius] (double?, optional): Corner radius in logical pixels.
  ///   Defaults to theme.radius * size for circular appearance.
  /// - [color] (Color?, optional): Background color. Defaults to theme primary.
  ///
  /// Example:
  /// ```dart
  /// CustomAvatarBadge(
  ///   color: Colors.red,
  ///   child: Text('5', style: TextStyle(color: Colors.white, fontSize: 8)),
  /// );
  /// ```
  const CustomAvatarBadge({
    super.key,
    this.child,
    double? width,
    this.height,
    this.borderRadius,
    this.color,
  }): size = width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = height ?? theme.scaling * 12;
    return Container(
      width: size,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            BorderRadius.circular(borderRadius ?? theme.radius * border),
      ),
      child: child,
    );
  }
}
