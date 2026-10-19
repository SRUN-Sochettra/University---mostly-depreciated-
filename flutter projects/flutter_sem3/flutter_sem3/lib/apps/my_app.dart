import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sem3/providers/color_notifier_provider.dart';
import 'package:flutter_sem3/providers/theme_notifier_provider.dart';
import 'package:flutter_sem3/screens/detail_screen.dart';
import 'package:flutter_sem3/screens/main_screen.dart';

List<Color> colorList = [
  Colors.yellow,
  Colors.lime,
  Colors.green,
  Colors.orange,
  Colors.deepOrange,
  Colors.pinkAccent,
  Colors.pink,
  Colors.red,
  Colors.deepPurple,
  Colors.cyanAccent,
  Colors.cyan,
  Colors.lightBlue,
  Colors.blue,
  Colors.indigo,
  Colors.grey,
];

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool dark = ref.watch(themeNotifierProvider);
    int index = ref.watch(colorNotifierProvider);
    Color seedColor = colorList[index];

    return MaterialApp(
      themeMode: dark ? .dark : .light,
      theme: ThemeData(
        brightness: .light,
        colorScheme: .fromSeed(seedColor: seedColor, brightness: .light),
      ),
      darkTheme: ThemeData(
        brightness: .dark,
        colorScheme: .fromSeed(seedColor: seedColor, brightness: .dark),
      ),
      // home: MainScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => MainScreen());
          case '/detail':
            return MaterialPageRoute(
              builder: (context) => DetailScreen(),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => Text("No Screen Found"),
            );
        }
      },
    );
  }
}
