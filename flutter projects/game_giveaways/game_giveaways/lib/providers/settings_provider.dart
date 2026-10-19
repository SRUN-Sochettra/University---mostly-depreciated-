import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';

class Appearance {
  const Appearance({
    this.mode = ThemeMode.system,
    this.accent = 'indigo',
    this.saving = false,
    this.error,
  });
  final ThemeMode mode;
  final String accent;
  final bool saving;
  final String? error;
}

class SettingsController extends AsyncNotifier<Appearance> {
  @override
  Future<Appearance> build() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('theme_mode');
    final accent = prefs.getString('theme_colour');
    return Appearance(
      mode: ThemeMode.values.firstWhere(
        (value) => value.name == mode,
        orElse: () => ThemeMode.system,
      ),
      accent: accents.containsKey(accent) ? accent! : 'indigo',
    );
  }

  Future<void> setAppearance({ThemeMode? mode, String? accent}) async {
    final previous = state.asData?.value;
    if (previous == null || previous.saving) {
      return;
    }
    if (accent != null && !accents.containsKey(accent)) {
      return;
    }
    final nextMode = mode ?? previous.mode;
    final nextAccent = accent ?? previous.accent;
    state = AsyncData(
      Appearance(mode: nextMode, accent: nextAccent, saving: true),
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = mode != null
          ? await prefs.setString('theme_mode', nextMode.name)
          : await prefs.setString('theme_colour', nextAccent);
      if (!saved) {
        throw Exception('Preference write failed.');
      }
      if (ref.mounted) {
        state = AsyncData(Appearance(mode: nextMode, accent: nextAccent));
      }
    } catch (_) {
      if (ref.mounted) {
        state = AsyncData(
          Appearance(
            mode: previous.mode,
            accent: previous.accent,
            error: 'Could not save this change. Your previous choice is still selected.',
          ),
        );
      }
    }
  }
}

final settingsProvider = AsyncNotifierProvider<SettingsController, Appearance>(
  SettingsController.new,
);
