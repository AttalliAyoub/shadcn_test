import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:test/expandable_sidebar_example_1.dart';
// import 'package:test/sheet_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  static bool dark = false;

  void toggleTheme([bool? value]) {
    setState(() {
      dark = value ?? !dark;
    });
  }

  ThemeData theme([bool? value]) {
    value ??= dark;
    return (value ? ThemeData.dark: ThemeData.new).call(
        colorScheme: ColorSchemes.zinc(value ? .dark : .light).emerald,
        radius: 1.5,
        density: Density.reducedDensity,
        surfaceOpacity: 0.9,
        surfaceBlur: 4.0,
      );
  }

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      darkTheme: theme(true),
      theme: theme(),
      themeMode: dark ? .dark : .light,
      // home: const MyHomePage(),
      // home: SheetExample1(),
      home: ExpandableSidebarExample1(),
    );
  }
}
