import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/open_link.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).requireValue;
    final controller = ref.read(settingsProvider.notifier);
    final colours = Theme.of(context).colorScheme;
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Appearance',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a comfortable view. Your choices stay with you.',
                style: TextStyle(color: colours.onSurfaceVariant, fontSize: 16),
              ),
              const SizedBox(height: 32),
              Text(
                'Display mode',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final mode in ThemeMode.values)
                      ChoiceChip(
                        label: Text(switch (mode) {
                          ThemeMode.system => 'System',
                          ThemeMode.light => 'Light',
                          ThemeMode.dark => 'Dark',
                        }),
                        selected: settings.mode == mode,
                        onSelected: settings.saving
                            ? null
                            : (_) => controller.setAppearance(mode: mode),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Accent colour',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                'Used for actions and selected controls.',
                style: TextStyle(color: colours.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final entry in accents.entries)
                      SizedBox(
                        width: 88,
                        child: Semantics(
                          selected: settings.accent == entry.key,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 4,
                              ),
                              foregroundColor: colours.onSurface,
                              side: BorderSide(
                                color: settings.accent == entry.key
                                    ? colours.primary
                                    : colours.outlineVariant,
                                width: settings.accent == entry.key ? 2 : 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: settings.saving
                                ? null
                                : () => controller.setAppearance(
                                    accent: entry.key,
                                  ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: entry.value,
                                    shape: BoxShape.circle,
                                  ),
                                  child: settings.accent == entry.key
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 18,
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  accentNames[entry.key]!,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (settings.saving)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text('Saving appearance...'),
                ),
              if (settings.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      settings.error!,
                      style: TextStyle(color: colours.error),
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              Text('LootDrop', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Giveaway listings provided by GamerPower.',
                style: TextStyle(color: colours.onSurfaceVariant),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () =>
                      openLink(context, 'https://www.gamerpower.com'),
                  child: const Text('Visit GamerPower'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
