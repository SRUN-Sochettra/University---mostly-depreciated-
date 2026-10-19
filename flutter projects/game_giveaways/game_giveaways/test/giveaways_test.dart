import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:game_giveaways/services/giveaway_api.dart';
import 'package:game_giveaways/providers/settings_provider.dart';

void main() {
  test('HTTP 201 is an empty list', () async {
    final client = MockClient((_) async => http.Response('', 201));
    addTearDown(client.close);
    expect(await fetchGiveaways(client), isEmpty);
  });
  test('Parses the minimum valid giveaway and supplies fallbacks', () async {
    final client = MockClient(
      (_) async => http.Response('[{"id":1,"title":"Test giveaway"}]', 200),
    );
    addTearDown(client.close);
    final items = await fetchGiveaways(client);
    expect(items.single.title, 'Test giveaway');
    expect(items.single.platforms, 'Not available');
    expect(items.single.url, isEmpty);
  });
  test('HTTP errors are not treated as empty results', () async {
    final client = MockClient((_) async => http.Response('', 500));
    addTearDown(client.close);
    await expectLater(fetchGiveaways(client), throwsException);
  });
  test('Rejects malformed payloads', () async {
    final client = MockClient((_) async => http.Response('{}', 200));
    addTearDown(client.close);
    await expectLater(fetchGiveaways(client), throwsFormatException);
  });
  test('Changing colour preserves dark mode', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(settingsProvider.notifier);
    controller.setDarkMode(true);
    controller.setColour('Green');
    expect(container.read(settingsProvider).darkMode, isTrue);
    expect(container.read(settingsProvider).colour, 'Green');
    controller.setColour('Unknown');
    expect(container.read(settingsProvider).colour, 'Green');
  });
}
