import 'dart:async';

import 'context.dart';
import 'package:flutter/cupertino.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

extension VisibilityContext<T extends StatefulWidget> on GlobalKey<State<T>> {
  Future<void> waitForVisibility({
    Duration checkInterval = const Duration(milliseconds: 100),
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (isWidgetVisible) return;
    final Completer<void> completer = Completer<void>();

    void checkVisibility(Timer timer) {
      if (isWidgetVisible) {
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
    if (currentContext == null) return null;
    final obj = currentContext!.findRenderObject();
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

  bool get isWidgetVisible {
    final renderBox = this.renderBox;
    if (renderBox == null) return false;

    // final parentData = renderBox.parentData as BoxParentData?;
    final parentData = renderBox.parentData;
    if (parentData is! BoxParentData) return false;
    if (parentData.offset.isInfinite) return false;
    final rect = this.rect!;
    final view = View.of(currentContext!);
    final windowRect = Offset.zero & view.physicalSize / view.devicePixelRatio;
    return windowRect.overlaps(rect);
  }

  Future<Uint8List?> captureWidget({
    double pixelRatio = 1.0,
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    if (currentContext == null) return null;
    return currentContext!.captureWidget(
      format: format,
      pixelRatio: pixelRatio,
    );
  }

  Future<ImageProvider<MemoryImage>?> captureProvider({
    double scale = 1.0,
    double pixelRatio = 1.0,
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    if (currentContext == null) return null;
    return currentContext!.captureProvider(
      format: format,
      pixelRatio: pixelRatio,
      scale: scale,
    );
  }
}
