# JMC Innovators Learning Platform — Flutter App

> **Native scaffolding added:** this project now includes full `android/` and
> `ios/` folders, `.gitignore`, `.metadata`, `analysis_options.yaml`, a
> `test/` smoke test, and `codemagic.yaml`, so it's ready for
> `flutter build apk` and Codemagic out of the box. See
> ["Building the app"](#building-the-app) below.
>
> **All 11 site pages recreated natively:** Home, Classroom, Exam Papers,
> Textbooks, Dictionary, AI Notebook, Science Lab (periodic table), Maths
> Lab (working calculators), AI Center/Chatbot, Tell Us (registration), and
> the Educational Tools hub each now have a real Flutter screen matching
> the corresponding page's layout and color theme — not a WebView wrapper.
> There's also a shared `WonderfulLoadingButton` (shimmering gradient +
> spinner) used for sign-in, downloads, and form submits, and a fully
> animated splash screen. See ["Setting up Google Sign-In"](#setting-up-google-sign-in)
> for the auth setup.


Native Flutter scaffold matching the branding of https://innovators-jmc.netlify.app,
covering every section from the spec: splash, onboarding, auth (Google / email /
phone OTP), home dashboard, explore grid, AI Center, AI Smart Notebook, JMC
Classroom, Exam Papers, Textbooks, Educational Videos, Science Lab, Math Lab,
Dictionary, Profile, Settings, and an Admin panel.

## Before you can build & run

This was generated without a Flutter SDK or network access, so nothing has
been compiled or tested. To get it running:

```bash
flutter pub get
flutterfire configure          # generates lib/firebase_options.dart
```

Then in `lib/main.dart`, uncomment:
```dart
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```
and add the matching import for `firebase_options.dart`.

## Wiring the AI Center to your existing backend

`lib/services/ai_service.dart` is written to call your team's existing
**JARK AI** backend (Node/Express + Groq) instead of standing up a second AI
service. Point it at your deployed backend without hardcoding the URL:

```bash
flutter run --dart-define=AI_BASE_URL=https://your-jark-ai-backend.example.com
```

Your Express route should accept `{ message, mode, history }` and return
`{ "reply": "..." }` — adjust the field name in `ai_service.dart` if your
existing endpoint differs. The spec mentioned a "GLM-5.2" model; if that's a
real, currently available API for your use case, swap the backend model call
inside your JARK AI server rather than re-pointing the Flutter app — the app
only talks to your own backend, never to a third-party model directly.

## What's real vs. stubbed

| Area | Status |
|---|---|
| Theme, navigation, all 20+ screens | Built with Material 3, functional local state |
| Firebase Auth (Google/email/phone) | Real `firebase_auth` calls — needs your Firebase project |
| AI Center | Real HTTP call — needs `AI_BASE_URL` pointed at JARK AI |
| Notebook | In-memory notes — swap for Hive + Firestore sync (packages already in `pubspec.yaml`) |
| Classroom, Exam Papers, Textbooks, Videos, Dictionary | Mock/local data — replace with Firestore queries or your existing content APIs |
| Admin panel | UI shell only — gate behind a Firestore role/custom-claim check before shipping |
| Offline caching, push notifications, Crashlytics, Remote Config, App Check | Not implemented — packages are in `pubspec.yaml`; wire up once Firebase project exists |

## Structure

```
lib/
  main.dart                 # entry point, splash->onboarding->auth->home flow
  theme/app_theme.dart       # brand colors + Material 3 ThemeData
  routes/app_router.dart      # named routes for feature screens
  services/                  # auth_service.dart, ai_service.dart
  widgets/                   # glass_card.dart, root_shell.dart (bottom nav)
  screens/                   # one folder per feature area
```

## Building the app

### Local build

```bash
flutter pub get
flutter build apk --release       # -> build/app/outputs/flutter-apk/app-release.apk
flutter build appbundle --release # -> build/app/outputs/bundle/release/app-release.aab
flutter build ios --release       # macOS + Xcode required; add signing before archiving
```

The Android side is preconfigured with:
- `applicationId` / `namespace`: `com.jmcinnovators.learning_platform`
- `minSdkVersion 23` (required by `firebase_auth`/`cloud_firestore`/`firebase_messaging`)
- `compileSdk`/`targetSdk 34`, Kotlin 1.9.24, Java 17, Gradle 8.6, AGP 8.3.2
- The Gradle wrapper (`gradlew`, `gradlew.bat`, `gradle/wrapper/gradle-wrapper.jar`)
  is committed, so CI doesn't need a system-wide Gradle install.
- Release builds currently sign with the **debug key** so
  `flutter build apk --release` works immediately. Before you publish, add a
  real keystore and either set `RELEASE_STORE_FILE` /
  `RELEASE_STORE_PASSWORD` / `RELEASE_KEY_ALIAS` / `RELEASE_KEY_PASSWORD` as
  Gradle properties, or wire up Codemagic's managed code signing.
- Launcher icons (Android mipmaps + iOS AppIcon.appiconset) are placeholder
  "J" monograms in the app's dark/violet palette — swap them for your real
  logo using `flutter_launcher_icons` (already a dev dependency) or by
  replacing the PNGs directly.

### Enabling Firebase for real

Firebase packages are in `pubspec.yaml`, but `Firebase.initializeApp()` is
commented out in `lib/main.dart` and the Google Services Gradle plugin is
commented out in `android/app/build.gradle` — this keeps the project
buildable with zero Firebase setup. To turn it on:

1. `flutterfire configure` (generates `lib/firebase_options.dart`, and
   downloads `android/app/google-services.json` +
   `ios/Runner/GoogleService-Info.plist` for you).
2. Uncomment `Firebase.initializeApp(...)` in `lib/main.dart` and its import.
3. In `android/build.gradle`, uncomment the `buildscript { ... }` block
   near the top (adds the `com.google.gms:google-services` classpath), and
   in `android/app/build.gradle` uncomment the
   `id "com.google.gms.google-services"` plugin line.
4. For iOS, add `GoogleService-Info.plist` to the `Runner` target in Xcode
   (drag it into the `Runner` group with "Copy items if needed" checked).

### Setting up Google Sign-In

The "Continue with Google" button in `lib/screens/auth/login_screen.dart`
already calls `AuthService.signInWithGoogle()`
(`lib/services/auth_service.dart`), which uses the `google_sign_in` +
`firebase_auth` packages already in `pubspec.yaml`. It won't work until you
connect it to a real Firebase project — here's the full setup, once:

**1. Create/open your Firebase project**
- Go to [console.firebase.google.com](https://console.firebase.google.com),
  create a project (or use an existing one).
- In **Authentication → Sign-in method**, enable **Google** as a provider.

**2. Run FlutterFire configure**
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
This registers your Android + iOS apps with Firebase, downloads
`android/app/google-services.json` and
`ios/Runner/GoogleService-Info.plist`, and generates
`lib/firebase_options.dart`. Pick the same package name/bundle ID already
set in this project: `com.jmcinnovators.learning_platform` (Android) /
`com.jmcinnovators.learningPlatform` (iOS) — or update those in
`android/app/build.gradle` and the Xcode project if you use your own.

**3. Add your Android app's SHA-1 fingerprint**
Google Sign-In on Android is keyed to your signing certificate's SHA-1, not
just the package name. Get it, then paste it into Firebase console →
Project settings → your Android app → "Add fingerprint":
```bash
# Debug keystore (for local testing / `flutter run`)
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Release keystore (once you have one — see "Building the app" above)
keytool -list -v -keystore /path/to/your-release-key.jks -alias your-key-alias
```
Copy the `SHA1:` value into Firebase, then re-download
`google-services.json` (fingerprints are baked into that file) and replace
`android/app/google-services.json`.

> If you build release APKs/AABs on Codemagic with **Codemagic-managed
> signing**, also add that keystore's SHA-1 the same way — it will differ
> from your local one.

**4. iOS: add the URL scheme**
`flutterfire configure` downloads `GoogleService-Info.plist`, which
contains a `REVERSED_CLIENT_ID`. Add it as a URL scheme so the Google
sign-in sheet can redirect back into the app:
- Open `ios/Runner.xcworkspace` in Xcode.
- Select **Runner → Info → URL Types → +**.
- Paste the `REVERSED_CLIENT_ID` value (from `GoogleService-Info.plist`)
  into the URL Schemes field.

**5. Uncomment Firebase initialization**
Do steps 2–3 from "Enabling Firebase for real" above
(`Firebase.initializeApp(...)` in `main.dart`, and the
`com.google.gms.google-services` Gradle plugin) — Google Sign-In needs
Firebase initialized before any auth call runs.

**6. Test it**
```bash
flutter pub get
flutter run
```
Tap "Continue with Google" — you should see the native account picker,
then land back in the app signed in. If it fails silently on Android, it's
almost always a missing/mismatched SHA-1 (step 3); on iOS, a missing URL
scheme (step 4).

### Codemagic

`codemagic.yaml` at the project root defines three workflows:
`android-apk`, `android-appbundle`, and `ios-workflow` (unsigned by default).
Push this repo to GitHub/GitLab/Bitbucket, connect it in the Codemagic
dashboard, and it will auto-detect `codemagic.yaml`. Add signing
identities under Codemagic's Code Signing settings for release-ready,
store-signed builds — see the comments at the bottom of `codemagic.yaml`.

## Suggested next milestones

1. Run `flutterfire configure`, confirm Google Sign-In works end-to-end.
2. Point `AI_BASE_URL` at JARK AI and confirm the chat round-trips.
3. Replace mock lists (exam papers, textbooks, classroom data) with real
   Firestore collections — start with one screen, expand the pattern to the rest.
4. Add app icons/splash via `flutter_launcher_icons` and `flutter_native_splash`
   (both already dev dependencies) using your existing logo assets.
5. Set up Firebase Cloud Messaging for the Notifications feature.
