# Archive notes

## Organisation

The supplied snapshot has four principal source areas: `flutter projects`, `web`, `lg lg` and `testing(leave nothing)`, plus a root Tailwind dependency manifest and one Git submodule declaration.

Most entries belong to Flutter projects because each checkout includes framework source plus Android, iOS, Linux, macOS, Windows and web scaffolding. File counts should not be interpreted as project importance or verified platform coverage.

## Canonical-project boundary

LootDrop and Nham24 are present inside this archive, but they also have their own project identities and documentation. Keep this archive's descriptions concise and point detailed release/verification claims to the canonical project repositories when available. The archive is useful as coursework history, not as the source of truth for every later standalone release.

## Known documentation drift

Several nested Flutter projects retain starter READMEs even though their source has grown beyond the starter template. Updating those individually should be a project-scoped change. The archive-level README does not rewrite nested documentation.

The root README previously referenced an Advanced Data Structures directory name that does not appear as a top-level path in the Repomix text entries. The material is represented within the archive, but its exact binary/notebook location should be checked in the original checkout before reorganising paths.

## Tooling boundaries

The root package.json declares Tailwind dependencies but no scripts or lockfile was identified in the text snapshot. Flutter projects carry independent `pubspec.yaml` and lockfiles. There is no root workspace configuration that builds or tests the entire monorepo.

The Git submodule points `flutter projects/Flutter---Semester-2` to the separate `flutter-course-semester-2` repository. Clone/update submodules explicitly when that content is needed.
