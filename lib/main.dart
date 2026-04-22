import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:test/sheet_example.dart';

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
      home: SheetExample1(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [AppBar(title: const Text('Ayoub Ayoub '))],
      child: Column(
        mainAxisAlignment: .center,
        children: [
          const Text('You have pushed the button this many times:'),
          Text('$_counter', style: Theme.of(context).typography.medium),
          Button.primary(
            onPressed: _incrementCounter,
            child: const Icon(Icons.add),
          ),
        ],
      ).center().withPadding(left: 20, right: 20),
    );
  }
}
