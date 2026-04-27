import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:test/expandable_sidebar_example_1.dart';
// import 'package:test/sheet_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorSchemes.darkZinc.emerald,
        radius: 1.5,
        density: Density.reducedDensity,
        surfaceOpacity: 0.9,
        surfaceBlur: 4.0,
      ),
      // home: const MyHomePage(),
      // home: SheetExample1(),
      home: ExpandableSidebarExample1(),
    );
  }
}
