# SkyCrew ✈️

**Professional Flight Crew Management Application**

A scalable Flutter POC for managing pilots, co-pilots, flight attendants, and supervisors with offline-first data management and a minimalist, calming design.

---

## Features

| Feature | Status |
|---|---|
| Email/password authentication | ✅ |
| Role-based UI (Pilot, Co-Pilot, Flight Attendant, Supervisor) | ✅ |
| Digital logbook (CRUD flight/duty records) | ✅ |
| Automatic block time & duty time calculations | ✅ |
| FTL compliance summary (monthly / yearly) | ✅ |
| PDF & CSV logbook export | ✅ |
| License & currency tracking with expiry alerts | ✅ |
| Fatigue & wellness self-assessment | ✅ |
| Fatigue trend chart (fl_chart) | ✅ |
| Offline-first sembast storage (Android · iOS · Web) | ✅ |
| Firebase Auth & Firestore ready | 🔜 (stub included) |
| Dark mode | ✅ |

---

## Architecture

```
lib/
├── app/                    # Routing & GetX bindings
│   ├── routes/
│   └── bindings/
├── config/                 # App & Firebase configuration
├── data/                   # Data layer
│   ├── datasources/        # SQLite, SharedPreferences, Firebase stubs
│   ├── models/             # SQLite row ↔ Entity mappers
│   ├── repositories/       # CRUD operations
│   └── mappers/            # Extension mappers
├── domain/                 # Business logic
│   ├── entities/           # Pure Dart domain models
│   └── usecases/           # Single-purpose use cases
├── presentation/           # UI layer
│   ├── bindings/           # GetX lazy dependency injection
│   ├── controllers/        # GetX state controllers
│   ├── views/              # Screen widgets
│   ├── widgets/            # Reusable UI components
│   └── theme/              # Colors, typography, Material 3 theme
└── utils/                  # Helpers, constants, exceptions
```

### State Management
**GetX** controller-view binding pattern:
- Controllers extend `GetxController` and expose `Rx<T>` observables
- Views use `GetView<Controller>` for automatic controller lookup
- Bindings wire dependencies via `Get.lazyPut()`

---

## Tech Stack

| Layer | Library | Web? |
|---|---|---|
| State management | `get ^4.6.6` | ✅ |
| Local database | `sembast ^3.7.2` + `sembast_web ^2.4.0` | ✅ (IndexedDB) |
| PDF export | `pdf ^3.10.8` | ✅ (browser download) |
| CSV export | `csv ^6.0.0` | ✅ (browser download) |
| Charts | `fl_chart ^0.68.0` | ✅ |
| Typography | `google_fonts ^6.2.1` (Inter) | ✅ |
| UUID generation | `uuid ^4.4.0` | ✅ |

---

## Design System

### Color Palette (Minimalist Japanese UI)

| Name | Hex | Usage |
|---|---|---|
| Matcha Green | `#4F6F52` | Primary brand, CTAs |
| Soft Green-Gray | `#D1D5C9` | Secondary, chips |
| Muted Sage | `#8FA897` | Tertiary accent |
| Muted Red | `#9F3A38` | Error, danger actions |
| Warm Off-White | `#F6F7F2` | Background |
| Outline | `#E1E4DA` | Borders, dividers |

### Typography
**Inter** (Google Fonts) — professional and highly legible on digital screens.

---

## Platform Support

| Platform | Output | Min version |
|---|---|---|
| **Android** | APK / AAB | Android 5.0 (API 21) |
| **iOS** | IPA | iOS 12.0 |
| **Web** | Static site | Chrome 89+ · Edge 89+ · Firefox 90+ · Safari 15+ |

---

## Getting Started

### Prerequisites

| Requirement | Version | Notes |
|---|---|---|
| Flutter | 3.x | `flutter --version` |
| Dart | 3.x | bundled with Flutter |
| Android Studio + Android SDK | latest stable | for Android APK |
| Xcode 15+ | latest stable | **macOS only** — for iOS IPA |
| Chrome / Edge | any | for Flutter Web |

### Installation

```bash
# Clone the repository
git clone https://github.com/mustseeum/sky_crew.git
cd sky_crew

# Install Dart/Flutter dependencies
flutter pub get
```

---

### 🤖 Android — build & run

```bash
# Run on a connected device or emulator
flutter run -d <device-id>

# Build a debug APK (for direct installation)
flutter build apk --debug

# Build a release APK (signed with debug key by default)
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Build an Android App Bundle (recommended for Play Store)
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

> **Note:** `android/app/build.gradle` sets `minSdkVersion flutter.minSdkVersion`
> which resolves to **API 21** in Flutter 3.x (Android 5.0 Lollipop and later).

---

### 🍎 iOS — build & run (macOS + Xcode required)

```bash
# Install CocoaPods dependencies (first time only)
cd ios && pod install && cd ..

# Run on a connected iPhone / iPad (or Simulator)
flutter run -d <device-id>

# Build a release IPA for TestFlight / App Store
flutter build ipa --release
# Output: build/ios/ipa/SkyCrew.ipa

# Open in Xcode to configure signing & capabilities
open ios/Runner.xcworkspace
```

> **Bundle ID:** `com.skycrew.app` — change in Xcode under
> *Runner → Signing & Capabilities* or in `ios/Runner.xcodeproj/project.pbxproj`.

---

### 🌐 Web — build & run

SkyCrew fully supports Flutter Web — all data is persisted in the browser's
**IndexedDB** via `sembast_web`. PDF/CSV exports trigger a **browser download**
instead of saving to a local file path.

```bash
# Development server (hot-reload)
flutter run -d chrome

# Production build (outputs to build/web/)
flutter build web --release

# Serve the production build locally for testing
cd build/web && python3 -m http.server 8080
# then open http://localhost:8080
```

> **Supported browsers:** Chrome 89+, Edge 89+, Firefox 90+, Safari 15+

---

### Running Tests

```bash
flutter test test/unit_test.dart
```

---

## Firebase Setup (Optional)

1. Create a Firebase project at https://console.firebase.google.com
2. Install the FlutterFire CLI: `dart pub global activate flutterfire_cli`
3. Configure: `flutterfire configure`
4. Set `AppConfig.isFirebaseEnabled = true` in `lib/config/app_config.dart`
5. Implement `FirebaseRemoteDatasource` in `lib/data/datasources/remote/`

---

## Aviation Rules (Calculation Engine)

`lib/utils/helpers/calculation_engine.dart` implements:

- **Block time** calculation (off-blocks → on-blocks)
- **Period filters**: this month, this year, last 28 days, last 90 days
- **FTL compliance** checks:
  - Monthly limit: ≤ 100 hours block time (EASA-based)
  - Yearly limit: ≤ 900 hours block time (EASA-based)
- **Summary generation**: totals, landings, compliance status

---

## Contributing

1. Create a feature branch from `main`
2. Follow Clean Architecture layers (no cross-layer imports)
3. Use GetX `Rx` for reactive state
4. Run `flutter test` before opening a PR

---

## License

MIT License — see [LICENSE](LICENSE) for details.
