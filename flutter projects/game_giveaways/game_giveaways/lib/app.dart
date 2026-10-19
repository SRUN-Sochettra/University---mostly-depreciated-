import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

class LootDropApp extends ConsumerWidget {
  const LootDropApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final appearance = settings.asData?.value ?? const Appearance();
    final seed = accents[appearance.accent]!;
    return MaterialApp(
      title: 'LootDrop',
      debugShowCheckedModeBanner: false,
      themeMode: appearance.mode,
      theme: appTheme(seed, Brightness.light),
      darkTheme: appTheme(seed, Brightness.dark),
      home: settings.when(
        data: (_) => const HomeScreen(),
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              semanticsLabel: 'Loading appearance',
            ),
          ),
        ),
        error: (_, _) => Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Could not load appearance settings.'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => ref.invalidate(settingsProvider),
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
