import 'dart:math';

import 'counter_logic.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import 'theme_logic.dart';

class CountApp extends StatelessWidget {
  const CountApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool dark = context.watch<ThemeLogic>().dark;

    double size = context.watch<CounterLogic>().counter.toDouble();

    Color seedColor = Colors.pink;

    return MaterialApp(
      home: HomeScreen(),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        brightness: Brightness.light,
        textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 18 + size)),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
        textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 18 + size)),
      ),
    );
  }
}
