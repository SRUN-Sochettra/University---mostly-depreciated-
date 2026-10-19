import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/*
Hallmark · pre-emit critique: P5 H5 E5 S5 R5 V5
Hallmark · Flutter adaptation · macrostructure: Refined Glass Directory Stack
tone: atmospheric · soft · premium card UI
theme: light/dark glassmorphism · stronger edges · stronger blur · tactile avatars
*/

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color backgroundTop;
  final Color backgroundBottom;
  final Color orbOne;
  final Color orbTwo;
  final Color orbThree;
  final Color glass;
  final Color glassStrong;
  final Color border;
  final Color borderStrong;
  final Color accent;
  final Color accentSoft;
  final Color ink;
  final Color muted;
  final Color gold;
  final Color goldText;
  final Color danger;
  final Color shadow;
  final Color highlight;
  final Color innerShadow;

  const AppColors({
    required this.backgroundTop,
    required this.backgroundBottom,
    required this.orbOne,
    required this.orbTwo,
    required this.orbThree,
    required this.glass,
    required this.glassStrong,
    required this.border,
    required this.borderStrong,
    required this.accent,
    required this.accentSoft,
    required this.ink,
    required this.muted,
    required this.gold,
    required this.goldText,
    required this.danger,
    required this.shadow,
    required this.highlight,
    required this.innerShadow,
  });

  @override
  AppColors copyWith({
    Color? backgroundTop,
    Color? backgroundBottom,
    Color? orbOne,
    Color? orbTwo,
    Color? orbThree,
    Color? glass,
    Color? glassStrong,
    Color? border,
    Color? borderStrong,
    Color? accent,
    Color? accentSoft,
    Color? ink,
    Color? muted,
    Color? gold,
    Color? goldText,
    Color? danger,
    Color? shadow,
    Color? highlight,
    Color? innerShadow,
  }) {
    return AppColors(
      backgroundTop: backgroundTop ?? this.backgroundTop,
      backgroundBottom: backgroundBottom ?? this.backgroundBottom,
      orbOne: orbOne ?? this.orbOne,
      orbTwo: orbTwo ?? this.orbTwo,
      orbThree: orbThree ?? this.orbThree,
      glass: glass ?? this.glass,
      glassStrong: glassStrong ?? this.glassStrong,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      gold: gold ?? this.gold,
      goldText: goldText ?? this.goldText,
      danger: danger ?? this.danger,
      shadow: shadow ?? this.shadow,
      highlight: highlight ?? this.highlight,
      innerShadow: innerShadow ?? this.innerShadow,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;

    return AppColors(
      backgroundTop: Color.lerp(backgroundTop, other.backgroundTop, t)!,
      backgroundBottom: Color.lerp(backgroundBottom, other.backgroundBottom, t)!,
      orbOne: Color.lerp(orbOne, other.orbOne, t)!,
      orbTwo: Color.lerp(orbTwo, other.orbTwo, t)!,
      orbThree: Color.lerp(orbThree, other.orbThree, t)!,
      glass: Color.lerp(glass, other.glass, t)!,
      glassStrong: Color.lerp(glassStrong, other.glassStrong, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      goldText: Color.lerp(goldText, other.goldText, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      innerShadow: Color.lerp(innerShadow, other.innerShadow, t)!,
    );
  }
}

extension AppThemeX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  List<BoxShadow> get glassShadow {
    return [
      BoxShadow(
        color: colors.shadow,
        blurRadius: 30,
        offset: const Offset(0, 18),
      ),
    ];
  }

  List<BoxShadow> get buttonShadow {
    return [
      BoxShadow(
        color: colors.shadow,
        blurRadius: 16,
        offset: const Offset(0, 9),
      ),
    ];
  }
}

class AppTheme {
  AppTheme._();

  static const double blur = 28;
  static const double radiusMd = 18;
  static const double radiusLg = 24;
  static const double radiusXl = 30;

  static const EdgeInsets screenPadding = EdgeInsets.fromLTRB(20, 16, 20, 24);
  static const EdgeInsets cardPadding = EdgeInsets.fromLTRB(20, 20, 18, 20);

  static const AppColors lightColors = AppColors(
    backgroundTop: Color(0xFFEFF7FF),
    backgroundBottom: Color(0xFFF7F0FF),
    orbOne: Color(0x664F8DFF),
    orbTwo: Color(0x55B975FF),
    orbThree: Color(0x44FFD37A),
    glass: Color(0xA6FFFFFF),
    glassStrong: Color(0xD9FFFFFF),
    border: Color(0xCCFFFFFF),
    borderStrong: Color(0xF2FFFFFF),
    accent: Color(0xFF326799),
    accentSoft: Color(0xFFE2F0FF),
    ink: Color(0xFF101827),
    muted: Color(0xFF4B5565),
    gold: Color(0xFFE7C875),
    goldText: Color(0xFF5B4210),
    danger: Color(0xFFD94A4A),
    shadow: Color(0x2464758B),
    highlight: Color(0xFFFFFFFF),
    innerShadow: Color(0x2D1F2937),
  );

  static const AppColors darkColors = AppColors(
    backgroundTop: Color(0xFF07111F),
    backgroundBottom: Color(0xFF160B24),
    orbOne: Color(0x664A90FF),
    orbTwo: Color(0x664F46E5),
    orbThree: Color(0x33F0B45B),
    glass: Color(0x64162336),
    glassStrong: Color(0x971E2D44),
    border: Color(0x40FFFFFF),
    borderStrong: Color(0x66FFFFFF),
    accent: Color(0xFFA8D0FF),
    accentSoft: Color(0xFF1D3554),
    ink: Color(0xFFF8FAFC),
    muted: Color(0xFFC0CBDB),
    gold: Color(0xFFE2C572),
    goldText: Color(0xFF2A210F),
    danger: Color(0xFFFF7A7A),
    shadow: Color(0x85000000),
    highlight: Color(0x22FFFFFF),
    innerShadow: Color(0x99000000),
  );

  static ThemeData light = _theme(
    brightness: Brightness.light,
    colors: lightColors,
  );

  static ThemeData dark = _theme(
    brightness: Brightness.dark,
    colors: darkColors,
  );

  static ThemeData _theme({
    required Brightness brightness,
    required AppColors colors,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.accent,
        brightness: brightness,
      ),
    );

    final textTheme = GoogleFonts.outfitTextTheme(base.textTheme).apply(
      bodyColor: colors.ink,
      displayColor: colors.ink,
    );

    return base.copyWith(
      scaffoldBackgroundColor: colors.backgroundBottom,
      textTheme: textTheme,
      extensions: [colors],
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colors.ink,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          color: colors.ink,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.accent,
          foregroundColor: brightness == Brightness.dark
              ? const Color(0xFF07111F)
              : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
    );
  }

  static TextStyle displayTitle(BuildContext context) {
    return GoogleFonts.outfit(
      fontSize: 36,
      height: 0.96,
      fontWeight: FontWeight.w900,
      letterSpacing: -1.35,
      color: context.colors.ink,
    );
  }

  static TextStyle subtitle(BuildContext context) {
    return GoogleFonts.outfit(
      fontSize: 15.5,
      height: 1.45,
      fontWeight: FontWeight.w600,
      color: context.colors.muted,
    );
  }

  static TextStyle cardTitle(BuildContext context) {
    return GoogleFonts.outfit(
      fontSize: 18.5,
      height: 1.08,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.35,
      color: context.colors.ink,
    );
  }

  static TextStyle handle(BuildContext context) {
    return GoogleFonts.outfit(
      fontSize: 14,
      height: 1.2,
      fontWeight: FontWeight.w600,
      color: context.colors.muted,
    );
  }

  static TextStyle body(BuildContext context) {
    return GoogleFonts.outfit(
      fontSize: 14,
      height: 1.35,
      fontWeight: FontWeight.w600,
      color: context.colors.ink,
    );
  }

  static TextStyle small(BuildContext context) {
    return GoogleFonts.outfit(
      fontSize: 12,
      fontWeight: FontWeight.w900,
      color: context.colors.goldText,
    );
  }
}
