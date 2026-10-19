import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:game_giveaways/models/giveaway.dart';
import 'package:game_giveaways/providers/feed_provider.dart';
import 'package:game_giveaways/providers/browse_provider.dart';
import 'package:game_giveaways/providers/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Metadata and parser validation', () {
    expect(hasValue('Not available'), isFalse);
    expect(hasValue('  '), isFalse);
    expect(hasValue('PC'), isTrue);
    expect(Giveaway.fromJson({'id': 1, 'title': 'Test'}).platforms, isEmpty);
    expect(
      () => Giveaway.fromJson({'title': 'Invalid'}),
      throwsFormatException,
    );
  });
  test('Search and filters compose without changing source', () {
    const items = [
      Giveaway(id: 1, title: 'Forest', type: 'Game', platforms: 'PC'),
      Giveaway(id: 2, title: 'Bonus', type: 'DLC and Loot', platforms: 'PC'),
      Giveaway(
        id: 3,
        title: 'Playtest',
        type: 'Early Access Beta',
        platforms: 'Steam',
      ),
    ];
    expect(filtered(items, const Browse(query: 'pc')).length, 2);
    expect(
      filtered(items, const Browse(category: GiveawayCategory.loot)).single.id,
      2,
    );
    expect(
      filtered(
        items,
        const Browse(query: 'pc', category: GiveawayCategory.beta),
      ),
      isEmpty,
    );
    expect(items.length, 3);
  });
  test('HTTP success and malformed response', () async {
    final good = MockClient(
      (_) async => http.Response('[{"id":1,"title":"Test"}]', 200),
    );
    addTearDown(good.close);
    expect((await fetchGiveaways(good)).single.title, 'Test');
    final bad = MockClient((_) async => http.Response('{}', 200));
    addTearDown(bad.close);
    await expectLater(fetchGiveaways(bad), throwsFormatException);
    final error = MockClient((_) async => http.Response('', 500));
    addTearDown(error.close);
    await expectLater(fetchGiveaways(error), throwsException);
  });
  test('Empty API response returns an empty list', () async {
    final client = MockClient((_) async => http.Response('', 201));
    addTearDown(client.close);
    expect(await fetchGiveaways(client), isEmpty);
  });
  test(
    'Refresh retains results, suppresses duplicates and handles failure',
    () async {
      var calls = 0;
      final pending = Completer<http.Response>();
      final refreshStarted = Completer<void>();
      final client = MockClient((_) async {
        calls++;
        if (calls == 1) {
          return http.Response('[{"id":1,"title":"Original"}]', 200);
        }
        if (!refreshStarted.isCompleted) {
          refreshStarted.complete();
        }
        return pending.future;
      });
      addTearDown(client.close);
      final container = ProviderContainer(
        overrides: [clientProvider.overrideWithValue(client)],
      );
      addTearDown(container.dispose);
      await container.read(feedProvider.future);
      final refresh = container.read(feedProvider.notifier).refresh();
      expect(
        container.read(feedProvider).requireValue.items.single.title,
        'Original',
      );
      expect(container.read(feedProvider).requireValue.refreshing, isTrue);
      await refreshStarted.future.timeout(const Duration(seconds: 5));
      expect(await container.read(feedProvider.notifier).refresh(), isFalse);
      expect(calls, 2);
      pending.complete(http.Response('', 500));
      expect(await refresh, isFalse);
      expect(calls, 2);
      expect(container.read(feedProvider).requireValue.failedRefresh, isTrue);
      expect(
        container.read(feedProvider).requireValue.items.single.title,
        'Original',
      );
    },
  );
  test('Refresh replaces results on success', () async {
    var calls = 0;
    final client = MockClient(
      (_) async => http.Response('[{"id":1,"title":"Result ${++calls}"}]', 200),
    );
    addTearDown(client.close);
    final container = ProviderContainer(
      overrides: [clientProvider.overrideWithValue(client)],
    );
    addTearDown(container.dispose);
    await container.read(feedProvider.future);
    expect(await container.read(feedProvider.notifier).refresh(), isTrue);
    expect(
      container.read(feedProvider).requireValue.items.single.title,
      'Result 2',
    );
  });
  test('Existing settings restored and changes persisted', () async {
    SharedPreferences.setMockInitialValues({
      'theme_mode': 'dark',
      'theme_colour': 'teal',
    });
    final first = ProviderContainer();
    final loaded = await first.read(settingsProvider.future);
    expect(loaded.mode, ThemeMode.dark);
    expect(loaded.accent, 'teal');
    await first.read(settingsProvider.notifier).setAppearance(accent: 'rose');
    first.dispose();
    final second = ProviderContainer();
    addTearDown(second.dispose);
    final restored = await second.read(settingsProvider.future);
    expect(restored.mode, ThemeMode.dark);
    expect(restored.accent, 'rose');
  });
}
