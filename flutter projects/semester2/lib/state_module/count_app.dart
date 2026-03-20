import 'package:flutter/material.dart';
import 'package:semester2/state_module/counter_logic.dart';
import 'theme_logic.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class CountApp extends StatelessWidget {
  const CountApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool dark = context.watch<ThemeLogic>().dark;
    Color seedColor = Colors.pink;
    Color secondaryColor = Colors.lime.shade300;
    double size = context.watch<CounterLogic>().counter.toDouble();

    return MaterialApp(
      home: HomeScreen(),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 18 + size)),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 18 + size)),
      ),
    );
  }
}
