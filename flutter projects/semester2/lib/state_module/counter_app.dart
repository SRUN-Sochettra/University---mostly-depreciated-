import 'package:flutter/material.dart';
import 'theme_logic.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class CountApp extends StatelessWidget {
  const CountApp({super.key});

  @override
  Widget build(BuildContext context) {

    bool dark = context.watch<ThemeLogic>().dark;

    return MaterialApp(
      home: HomeScreen(),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lime,
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}
