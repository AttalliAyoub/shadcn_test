import 'package:flutter_animate/flutter_animate.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'resp.dart' show Resp;
import 'responsive.dart' show BreakPoints;
export 'visibility_extention.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

extension MyBuildContext on BuildContext {
  Future<void> waitForVisibility({
    Duration checkInterval = const Duration(milliseconds: 100),
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (isVisible) return;
    final Completer<void> completer = Completer<void>();

    void checkVisibility(Timer timer) {
      if (isVisible) {
        timer.cancel();
        completer.complete();
        return;
      }
      final duration = timer.tick * checkInterval.inMilliseconds;
      if (duration < timeout.inMilliseconds) return;
      timer.cancel();
      completer.completeError(
        TimeoutException(
          'Widget did not become visible within the specified timeout.',
        ),
      );
    }

    Timer.periodic(checkInterval, checkVisibility);
    return completer.future;
  }

  RenderBox? get renderBox {
    final obj = findRenderObject();
    if (obj == null || !obj.attached) return null;
    return obj as RenderBox;
  }

  Offset? get postions {
    final renderBox = this.renderBox;
    if (renderBox == null) return null;
    return renderBox.localToGlobal(Offset.zero);
  }

  Size? get size {
    final renderBox = this.renderBox;
    if (renderBox == null) return null;
    return renderBox.size;
  }

  Rect? get rect {
    final size = this.size;
    if (size == null) return null;
    final postions = this.postions;
    if (postions == null) return null;
    return postions & size;
  }

  bool get isVisible {
    final renderBox = this.renderBox;
    if (renderBox == null) return false;

    // final parentData = renderBox.parentData as BoxParentData?;
    final parentData = renderBox.parentData;
    if (parentData is! BoxParentData) return false;
    if (parentData.offset.isInfinite) return false;
    final rect = this.rect!;
    final view = View.of(this);
    final windowRect = Offset.zero & view.physicalSize / view.devicePixelRatio;
    return windowRect.overlaps(rect);
  }

  static const defaultMediaQuery = MediaQueryData();
  MediaQueryData get mediaQuery =>
      MediaQuery.maybeOf(this) ?? defaultMediaQuery;
  Size get screenSize => MediaQuery.maybeSizeOf(this) ?? defaultMediaQuery.size;
  EdgeInsets get padding =>
      MediaQuery.maybePaddingOf(this) ?? defaultMediaQuery.padding;
  double get width => screenSize.width;
  double get height => screenSize.height;

  bool get mobile => BreakPoints.mobile.isSize(width);
  bool get tablet => BreakPoints.tablet.isSize(width);
  // bool get desktop => BreakPoints.desktop.isSize(width);
  bool get desktop => BreakPoints.desktop.moreThan(width);
  // bool get large => BreakPoints.large.isSize(width);
  bool get large => BreakPoints.large.moreThan(width);

  BreakPoints get breakpoint =>
      BreakPoints.values.reversed.firstWhere((bpoint) {
        if (bpoint.index == 0) return false;
        if (bpoint.isDesktop) return bpoint.moreThan(width);
        final result = BreakPoints.tablet.isSize(width) || bpoint.isSize(width);
        return result;
      }, orElse: () => BreakPoints.tablet);

  bool get isDarkMode => Resp.dark;

	// TODO: theme helpers
  ThemeData get theme => Theme.of(this);
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
	// TODO: theme helpers

  TextDirection get textDir => Directionality.of(this);
  bool get lor => textDir == TextDirection.ltr;
  bool get dir => lor;
  Alignment get dirAlignment => lorAlignment;
  Alignment get lorAlignment {
    if (lor) return Alignment.centerRight.resolve(textDir);
    return Alignment.centerLeft.resolve(textDir);
  }

  Alignment get reverseDirAlignment => reverseLorAlignment;
  Alignment get reverseLorAlignment {
    if (lor) return Alignment.centerLeft.resolve(textDir);
    return Alignment.centerRight.resolve(textDir);
  }

  void requestFocus(FocusNode focusNode) {
    return FocusScope.of(this).requestFocus(focusNode);
  }

  OverlayState get overlay => Overlay.of(this);
  OverlayState? get maybeOverlay => Overlay.maybeOf(this);

  Future<Uint8List?> captureWidget({
    double pixelRatio = 1.0,
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    try {
      final boundary = findRenderObject();
      if (boundary is! RenderRepaintBoundary) return null;
      // Check if the widget is ready to be painted
      if (boundary.debugNeedsPaint) {
        await 20.milliseconds.delay;
        return captureWidget();
      }
      final image = await boundary.toImage(
        pixelRatio: pixelRatio,
      ); // Use 3.0 for high resolution
      final byteData = await image.toByteData(format: format);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ImageProvider<MemoryImage>?> captureProvider({
    double scale = 1.0,
    double pixelRatio = 1.0,
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    final data = await captureWidget(format: format, pixelRatio: pixelRatio);
    if (data == null) return null;
    return MemoryImage(data, scale: scale);
  }

}


extension MyDuration on Duration {
  bool isNear(
    Duration other, [
    Duration threshold = const Duration(seconds: 5),
  ]) {
    // .abs() ensures the difference is positive regardless of which is larger
    return (this - other).abs() <= threshold;
  }

  DateTime add2Date(DateTime date) => date.add(this);

  //  =====================
  Future<T> delayed<T>([FutureOr<T> Function()? computation]) =>
      Future<T>.delayed(this, computation);

  Future get delay => delayed();

  DateTimeRange toDateTimeRange(DateTime? end, [DateTime? start]) {
    end ??= DateTime.now();
    start ??= end.subtract(this);
    return DateTimeRange(start, end);
  }

}
