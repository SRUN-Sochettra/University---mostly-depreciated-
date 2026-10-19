import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:game_giveaways/providers/feed_provider.dart';
import 'package:game_giveaways/providers/settings_provider.dart';
import 'package:game_giveaways/screens/home_screen.dart';
import 'package:game_giveaways/theme/app_theme.dart';

void main() {
  WidgetController.hitTestWarningShouldBeFatal = true;
  for (final width in [320.0, 390.0, 768.0]) {
    for (final scale in [1.0, 2.0]) {
      for (final brightness in Brightness.values) {
        testWidgets('Browse/details/settings: $width / $scale / $brightness', (
          tester,
        ) async {
          tester.view.physicalSize = Size(width, 900);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          SharedPreferences.setMockInitialValues({});
          final client = MockClient(
            (_) async => http.Response(
              '[{"id":1,"title":"A deliberately long giveaway title for layout testing",'
              '"type":"Game","platforms":"PC, Steam, DRM-Free",'
              '"worth":"\$5.99","description":"Description","instructions":"Claim instructions"}]',
              200,
            ),
          );
          addTearDown(client.close);
          final container = ProviderContainer(
            overrides: [clientProvider.overrideWithValue(client)],
          );
          addTearDown(container.dispose);
          await container.read(settingsProvider.future);
          await container.read(feedProvider.future);
          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: MaterialApp(
                theme: appTheme(accents['teal']!, brightness),
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(scale)),
                  child: child!,
                ),
                home: const HomeScreen(),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(find.text('Free'), findsOneWidget);
          final title = find.text(
            'A deliberately long giveaway title for layout testing',
          );
          // A large-text card may be taller than the visible grid viewport.
          // Scroll the real grid until the title can actually receive a tap.
          for (
            var attempt = 0;
            attempt < 12 && title.hitTestable().evaluate().isEmpty;
            attempt++
          ) {
            await tester.drag(
              find.byType(GridView).first,
              const Offset(0, -100),
            );
            await tester.pumpAndSettle();
          }
          expect(
            title.hitTestable(),
            findsOneWidget,
            reason: 'The giveaway title must be reachable at this text scale.',
          );
          await tester.tap(title.hitTestable());
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(find.text('Get giveaway'), findsOneWidget);
          await tester.pageBack();
          await tester.pumpAndSettle();
          await tester.tap(find.text('Appearance').last);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(find.text('Display mode'), findsOneWidget);
        });
      }
    }
  }
}
