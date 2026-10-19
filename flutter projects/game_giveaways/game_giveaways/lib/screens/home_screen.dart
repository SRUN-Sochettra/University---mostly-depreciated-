import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/browse_provider.dart';
import 'game_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    body: IndexedStack(
      index: ref.watch(navigationProvider),
      children: const [GameScreen(), SettingsScreen()],
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: ref.watch(navigationProvider),
      onDestinationSelected: ref.read(navigationProvider.notifier).select,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.grid_view_outlined),
          selectedIcon: Icon(Icons.grid_view_rounded),
          label: 'Discover',
        ),
        NavigationDestination(
          icon: Icon(Icons.tune_rounded),
          label: 'Appearance',
        ),
      ],
    ),
  );
}
