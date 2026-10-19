import 'package:flutter/material.dart';

const accents = <String, Color>{
  'indigo': Color(0xFF6558D3),
  'violet': Color(0xFF7C3AED),
  'blue': Color(0xFF1976D2),
  'cyan': Color(0xFF00838F),
  'teal': Color(0xFF00796B),
  'green': Color(0xFF388E3C),
  'lime': Color(0xFF6B7D00),
  'amber': Color(0xFF9A6700),
  'orange': Color(0xFFCC5000),
  'red': Color(0xFFC62828),
  'rose': Color(0xFFB13F68),
  'pink': Color(0xFFC2185B),
};
const accentNames = <String, String>{
  'indigo': 'Indigo',
  'violet': 'Violet',
  'blue': 'Ocean',
  'cyan': 'Cyan',
  'teal': 'Teal',
  'green': 'Forest',
  'lime': 'Lime',
  'amber': 'Amber',
  'orange': 'Ember',
  'red': 'Crimson',
  'rose': 'Rose',
  'pink': 'Pink',
};

ThemeData appTheme(Color seed, Brightness brightness) {
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
  final dark = brightness == Brightness.dark;
  final background = dark ? const Color(0xFF101315) : const Color(0xFFFAFAF8);
  final base = ThemeData(useMaterial3: true, colorScheme: scheme);
  return base.copyWith(
    scaffoldBackgroundColor: background,
    textTheme: base.textTheme.copyWith(
      headlineLarge: base.textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
      ),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.6),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: dark ? const Color(0xFF191D20) : Colors.white,
      elevation: 0,
      indicatorColor: scheme.secondaryContainer,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      selectedColor: scheme.secondaryContainer,
      labelStyle: TextStyle(
        color: scheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(color: scheme.outlineVariant),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
