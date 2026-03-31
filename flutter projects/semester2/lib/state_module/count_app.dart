import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'theme_logic.dart';
import 'counter_logic.dart';

class CountApp extends StatelessWidget {
  const CountApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeLogic()),
        ChangeNotifierProvider(create: (_) => CounterLogic()),
      ],
      child: _AppContent(),
    );
  }
}

class _AppContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool dark = context.watch<ThemeLogic>().dark;
    Color seedColor = Colors.amber;
    double size = context.watch<CounterLogic>().counter.toDouble();
    return MaterialApp(
      home: HomeScreen(),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light, // ✅ moved here
        ),
        textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 16 + size)),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark, // ✅ moved here
        ),
      ),
    );
  }
}
