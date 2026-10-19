import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sem3/apps/my_app.dart';
import 'package:flutter_sem3/providers/color_notifier_provider.dart';
import 'package:flutter_sem3/providers/theme_notifier_provider.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = ref.watch(themeNotifierProvider);
    final selectedIndex = ref.watch(colorNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: const Text('Night Mode'),
              trailing: Switch(
                value: dark,
                onChanged: (value) {
                  ref.read(themeNotifierProvider.notifier).toggleDark();
                },
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: colorList.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 80,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final color = colorList[index];

                  return InkWell(
                    onTap: () {
                      ref
                          .read(colorNotifierProvider.notifier)
                          .changeIndex(index);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: color,
                      child: selectedIndex == index
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
