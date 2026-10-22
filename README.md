# University Code Archive

**A monorepo of university coursework, lab exercises and selected application projects across mobile, web and Python development.**

This repository is an academic archive rather than one deployable product. Each project keeps its own entry point, dependencies and platform configuration. Run and evaluate work from the relevant subdirectory instead of treating the repository root as a unified application.

## Archive map

### Flutter and Dart

| Project | Source-backed scope |
| --- | --- |
| `flutter projects/flutter_final_exam_sem2` | Glass-styled user browser backed by Fake Store API user data, profile details and theme switching |
| `flutter projects/flutter_sem3/flutter_sem3` | Seafood-meal browser using TheMealDB, Riverpod, cached images, details, settings and persistent navigation |
| `flutter projects/game_giveaways/game_giveaways` | LootDrop giveaway catalogue using GamerPower, Riverpod, local search/filtering, details and appearance settings |
| `flutter projects/nham24` | Food-delivery interface study with restaurant/menu browsing and an in-memory cart; checkout remains a placeholder |
| `flutter projects/flutter_application_1` | Smaller Flutter UI/coursework exercises |
| `flutter projects/Flutter---Semester-2` | Git submodule pointing to the separate `flutter-course-semester-2` repository |

The Flutter projects include generated platform scaffolding for multiple targets. A platform directory's presence does not establish that the application was built or verified on that platform.

### Web coursework

The `web` tree contains HTML/CSS exercises, JavaScript DOM interactions, forms, responsive layouts, Flexbox practice, Tailwind/Flowbite work, heritage and UNESCO pages, plus a React/Vite Spotify interface exercise.

The root `package.json` declares Tailwind CSS CLI dependencies. It does not define repository-wide scripts or install dependencies for nested React/Flutter projects.

### Python and data structures

The `lg lg` and related coursework files contain Python fundamentals, utility scripts, algorithms and object-oriented exercises. The archive also includes an Advanced Data Structures notebook covering structures such as binary search trees, linked lists, maps and an LRU-cache exercise.

Notebooks are binary/JSON-heavy learning artefacts. Their presence is not a fresh execution result, benchmark or correctness proof.

## Working with the archive

Clone with submodules if you need the separately hosted semester-two Flutter material:

```sh
git clone --recurse-submodules <repository-url>
```

For an existing checkout:

```sh
git submodule update --init --recursive
```

Then enter the specific project directory and use its own manifest and README.

### Flutter project example

```sh
cd "flutter projects/game_giveaways/game_giveaways"
flutter pub get
flutter analyze
flutter test
flutter run
```

These commands are examples based on that project's Flutter manifest and test structure. They were not executed during this documentation refresh. Other Flutter directories have different dependencies and may not have meaningful tests.

### Root Tailwind dependencies

```sh
npm install
```

The root manifest contains dependencies only and no scripts. Inspect the intended input/output paths in the relevant coursework folder before invoking the Tailwind CLI. Nested React/Vite projects may have their own manifests and commands.

### Python exercise example

```sh
python "lg lg/algorithm.py"
```

Review each script first. Some exercises make external requests or depend on local input. No repository-wide Python dependency file or supported Python-version declaration is supplied.

## Important archive boundaries

- This repository contains coursework snapshots at different levels of completeness. Starter READMEs, placeholder actions and generated platform files should not be presented as finished product features.
- Several substantial Flutter projects also exist as separate repositories. This archive should remain the historical/coursework collection rather than the canonical release source for those projects.
- The `testing(leave nothing)` path is preserved as historical material; its name is not a verification guarantee.
- Existing project-specific claims, including older test counts, APK sizes and live API observations, have not been rerun by this archive-level refresh.
- External APIs and resources can change independently. Fake Store API, TheMealDB and GamerPower-dependent screens require fresh runtime checks.

## Repository hygiene

A Python script under `lg lg/.vscode` appears to contain a hard-coded weather-service credential. Do not publish or reuse it. If it is valid, rotate it with the provider and clean repository history appropriately. This documentation does not reproduce or remove the value.

Generated build folders, IDE files and per-platform scaffolding make the archive large. Do not delete them through this overlay; use a separate, reviewed cleanup change if the goal is reducing repository size. Likewise, preserve the Git submodule configuration unless intentionally consolidating repositories.

## Verification

This documentation refresh inspected 604 text entries from the attached Repomix snapshot. It reviewed the root structure, manifests, project READMEs and representative application sources. The supplied eight Python files were syntax-parsed; this was not execution and does not verify external requests or behaviour.

No Flutter, Dart, Node, React, PHP, notebook, browser or platform build was run. Binary assets excluded by Repomix were not inspected. See [archive notes](docs/archive-notes.md), [CONTRIBUTING.md](CONTRIBUTING.md), [SECURITY.md](SECURITY.md) and [refresh notes](docs/repository-refresh.md).

## Author and licence

Maintained by Srun Sochettra as an academic code archive. No root licence file is included in the supplied snapshot. Nested generated notices or dependency licences do not automatically license the repository's coursework. This refresh assigns none.
