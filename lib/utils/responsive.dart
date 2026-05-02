import 'context.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

enum BreakPoints {
  _zero,
  mobile,
  tablet,
  desktop,
  large;

  bool get isDesktop => this == desktop || this == large;
  bool get isTablet => this == tablet;
  bool get isMobile => this == mobile;

  static final _points = {
    _zero: 0.0,
    mobile: 672.0,
    tablet: 990.0,
    desktop: 1296.0,
    large: 1640.0,
  };

  BreakPoints get _back => values[index - 1];

  double get value => _points[this]!;

  bool moreThan(double width) => width > value;

  bool isSize(double width) {
    if (this == large) return width > _back.value;
    return width > _back.value && width < value;
  }
}

mixin ResponsiveMxin<T extends StatefulWidget> on State<T> {
  MediaQueryData get mediaQuery => context.mediaQuery;
  Size get screenSize => context.screenSize;
  EdgeInsets get padding => context.padding;
  double get width => context.width;
  double get height => context.height;
  bool get mobile => context.mobile;
  bool get tablet => context.tablet;
  bool get desktop => context.desktop;
  bool get large => context.large;
  bool get isDarkMode => context.isDarkMode;
  ThemeData get theme => context.theme;
  ColorScheme get colorScheme => theme.colorScheme;
  Typography get typography => theme.typography;

  Color get primary => colorScheme.primary;
  Color get secondary => colorScheme.secondary;
  Color get muted => colorScheme.muted;
  Color get destructive => colorScheme.destructive;
  Color get accent => colorScheme.accent;


	Color get primaryForeground => colorScheme.primaryForeground;
  Color get secondaryForeground => colorScheme.secondaryForeground;
  Color get mutedForeground => colorScheme.mutedForeground;
  Color get destructiveForeground => Colors.white;
  Color get accentForeground => colorScheme.accentForeground;

}
