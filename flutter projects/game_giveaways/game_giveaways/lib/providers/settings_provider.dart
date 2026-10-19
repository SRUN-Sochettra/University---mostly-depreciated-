import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings.dart';
import '../theme/theme_colours.dart';

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => const AppSettings();

  void setDarkMode(bool value) {
    state = AppSettings(darkMode: value, colour: state.colour);
  }

  void setColour(String value) {
    if (!themeColours.containsKey(value)) return;
    state = AppSettings(darkMode: state.darkMode, colour: value);
  }
}

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);
