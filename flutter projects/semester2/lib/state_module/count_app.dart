import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_logic.dart';
import 'counter_logic.dart';
import 'main_screen.dart';

class CountApp extends StatelessWidget {
  const CountApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool dark = context.watch<ThemLogic>().dark;
    Color seedColor = Colors.deepOrange;
    Color seedSecondary = Colors.lime.shade300;
    Color appBarColor = Colors.deepOrange.shade400;
    double size = context.watch<CounterLogic>().counter.toDouble();
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: MainScreen(),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 18 + size)),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: seedSecondary,
          shape: CircleBorder(),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: appBarColor,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 16 + size)),
      ),
    );
  }
}
