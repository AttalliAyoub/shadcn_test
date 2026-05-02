import 'package:test/main.dart';

import 'context.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class Resp {
  Resp._();

  static bool get dark => MyAppState.dark;

  static bool lor(BuildContext context) => context.lor;
  static bool dir(BuildContext context) => context.dir;
  static AlignmentGeometry dirAlignment(BuildContext context) =>
      context.dirAlignment;
  static AlignmentGeometry lorAlignment(BuildContext context) =>
      context.lorAlignment;

}
