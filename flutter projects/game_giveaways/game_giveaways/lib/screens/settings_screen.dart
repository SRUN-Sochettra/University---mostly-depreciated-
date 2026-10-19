import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';
import '../theme/theme_colours.dart';
import '../widgets/attribution.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.dark_mode_outlined),
          title: const Text('Dark mode'),
          subtitle: const Text('Use a dark appearance throughout the app'),
          value: settings.darkMode,
          onChanged: controller.setDarkMode,
        ),
        const Divider(height: 32),
        Text('Theme colour', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final entry in themeColours.entries)
              ChoiceChip(
                avatar: Icon(Icons.circle, color: entry.value, size: 18),
                label: Text(entry.key),
                selected: settings.colour == entry.key,
                onSelected: (_) => controller.setColour(entry.key),
              ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Appearance settings apply immediately. '
          'This simple example resets them when the app restarts.',
        ),
        const Attribution(),
      ],
    );
  }
}
