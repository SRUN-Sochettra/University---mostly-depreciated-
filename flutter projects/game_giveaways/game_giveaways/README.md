# Game Giveaways: structured Flutter source

This ZIP replaces the earlier single-file implementation. No new dependencies.

## Apply to your existing project

You already created the Flutter project and installed flutter_riverpod, http and url_launcher. Do not create another project.

1. In the inner game_giveaways project (the directory containing pubspec.yaml), merge this archive's lib and test folders. Replace lib/main.dart.
2. Remove the generated test/widget_test.dart, which targets the starter counter app.
3. For Android, add the INTERNET permission directly inside the manifest root in android/app/src/main/AndroidManifest.xml:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

4. Run:

```sh
dart format lib test
flutter analyze
flutter test
flutter run
```

## Structure

- main.dart: ProviderScope and application bootstrap only.
- app.dart: MaterialApp and theme configuration.
- models/: giveaway parsing and settings state.
- services/: HTTP request and response parsing.
- providers/: Riverpod data, navigation and settings controllers.
- screens/: home navigation shell, game grid, details and settings.
- widgets/: reusable giveaway card, image fallback and attribution.
- theme/: available seed colours.
- utils/: browser link opening.

The game screen uses GridView.builder. Settings apply immediately across the app but reset on restart. No persistence was added. This is a source overlay, not a full generated platform project.

## Verification

The refactor preserves the previous implementations, apart from updated imports. ZIP integrity, relative import targets, declaration placement and balanced delimiters were checked. Flutter and Dart are unavailable here, so compilation, analysis, tests and visual behaviour have NOT been verified. Five authored regression tests are included, not claimed as passing.

The earlier README incorrectly claimed official documentation had been inspected. Those requests failed; no documentation or live API response was retrieved. The parser's field names and HTTP 201 handling remain assumptions to verify against the actual service. No real giveaway data is bundled. Web CORS behaviour is unverified.
