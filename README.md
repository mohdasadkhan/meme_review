# Meme Arena

Premium social meme community with asynchronous 1v1 meme battles.

Package name: `meme_review` · Application ID: `com.asadcoder.meme_review`

## Stack

- Flutter (Bloc/Cubit, GoRouter, GetIt)
- Firebase Core + Firebase Auth
- Google Sign-In

## Architecture

Feature-first layout under `lib/`:

```
lib/
  app/           # App shell, theme, router, home landing
  core/          # DI, errors, constants, reusable widgets
  features/
    authentication/
    profile/
```

Business logic stays in repositories and cubits. Widgets remain presentation-only.

## Prerequisites

1. Flutter 3.35+ / Dart 3.9+
2. Android `google-services.json` at `android/app/google-services.json`
3. FlutterFire CLI for multi-platform Firebase options (recommended)

### FlutterFire CLI (recommended before multi-platform work)

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates `lib/firebase_options.dart`. Until then, Android initializes Firebase from the native Google Services plugin + `google-services.json`.

### Google Sign-In checklist

1. Firebase Console → Authentication → Sign-in method → enable **Google**
2. Add your debug/release SHA-1 (and SHA-256) fingerprints to the Android app in Firebase
3. Download an updated `google-services.json` if Firebase regenerates OAuth clients
4. Rebuild the app after fingerprint changes

Get the debug SHA-1:

```bash
cd android
./gradlew signingReport
```

## Run

```bash
flutter pub get
flutter run
```

## Verify

```bash
dart format .
flutter analyze
flutter test
```

## Current foundation

- Firebase Core initialization
- Dark-first theme + design tokens
- GoRouter navigation (home, sign-in, profile)
- GetIt DI + AuthCubit
- Google Sign-In integration (requires console setup above)
- `UserProfile` domain model
- Reusable UI primitives

## Not implemented yet

Meme upload, battles, likes, matchmaking, and moderation.
