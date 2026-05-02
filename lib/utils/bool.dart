import 'package:flutter/widgets.dart';

typedef BoolBuilder<T> = T Function(bool value);

extension BoolExt on bool {
  T build<T extends Widget?>(BoolBuilder<T> builder) {
    return builder(this);
  }

  Widget trueBuild(Widget child) {
    if (this) return child;
    return SizedBox.shrink();
  }
}
