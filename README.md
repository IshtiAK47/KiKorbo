# KiKorbo? (কী করবো?)

<div align="center">

<img src="appicon.png" alt="KiKorbo App Icon" width="128" height="128" style="border-radius: 28px;" />

### *“What should I do now?”*

An intentional, ultra-lightweight, offline-first daily scheduler crafted to keep you in flow without the anxiety of bloated productivity suites.

[![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white)](https://android.com)
[![Architecture](https://img.shields.io/badge/State-Riverpod%202.x-blueviolet)](https://riverpod.dev)
[![Database](https://img.shields.io/badge/Database-SQLite%20(Offline)-003B57?logo=sqlite&logoColor=white)](https://sqlite.org)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

</div>

---

## 🧭 Product Philosophy

Most productivity apps fail because they feel like unpaid administrative jobs: endless task lists, complex Kanban boards, gamified guilt, and cloud sync barriers.

**KiKorbo?** replaces all of that with a single, calm loop:

<div align="center">

**Plan → Reminder → Start → Complete → Next**

</div>

Open the app. Look at your screen. You instantly know what you should be doing right now.

---

## ✨ Features

### ⚡ Hero "NOW" Command Center
- **Context-Aware Engine**: Instantly computes what activity is active right now based on local time.
- **Smart Adaptive States**:
  - **Active Task**: Displays the active title, category, elapsed time, and remaining countdown.
  - **Free Time**: Recognizes gaps between tasks and displays how long until your next commitment.
  - **Day Complete**: Celebrates when all planned activities for today are finished.
  - **Clear Schedule**: Invites you to plan with zero stress.
- **Single-Tap Focus**: Jump straight from the current task into an immersive focus timer.

### 📅 Precision Daily Schedule & Timeline
- **Chronological Flow**: Continuous vertical timeline with connecting tracks and active progress indicators.
- **Date Selector Strip**: Fast horizontal multi-day scrubber with 1-tap "Jump to Today".
- **Responsive Layout**: Designed and tested across varied phone display densities and accessibility font sizes with zero layout overflow.
- **Conflict & Overlap Intelligence**: Non-blocking warning indicators if two planned tasks collide in time.

### ⏱️ Immersive Focus & Pomodoro Timer
- **Breathing Visuals**: Custom-painted circular progress ring (`TimerRingPainter`) with pulsating ambient glow.
- **Flexible Modes**: Switch seamlessly between standard 25-minute Pomodoro, custom task duration countdowns, or short breaks.
- **Haptic Feedback**: Subtle vibration cues on play, pause, reset, and session completion.

### 🎨 6 Hand-Crafted Visual Themes
Every theme features curated color harmonies, surface elevations, text contrast levels, and ambient gradient backdrops:
- ⚪ **Minimal**: Clean monochrome & off-white Apple-inspired elegance.
- 🌌 **Midnight**: Deep dark navy with cyan luminescence (Default).
- 🌸 **Sakura**: Serene warm ivory with soft cherry blossom rose accents.
- 🌲 **Forest**: Deep woodland green with tranquil emerald highlights.
- 🕹️ **Arcade**: Retro synthwave dark slate with vibrant amber neon.
- 🪐 **Cosmos**: Interstellar night sky with dreamy nebula violet.

### 📴 100% Offline-First & Private
- Local SQLite database powered by `sqflite`.
- No login. No mandatory cloud sync. No background tracking or analytics.
- Instant sub-millisecond cold start.

### 🔔 Timezone-Aware Local Notifications
- Scheduled start-time alerts using `flutter_local_notifications` and exact alarm scheduling.
- Notifies you when focus intervals conclude even when your screen is locked.

---

## 🏗️ Architecture & Project Structure

The project follows a modular, feature-first structure with clean separation of domain data, state notifiers, and presentation:

```text
lib/
├── core/
│   ├── constants/        # AppConstants & TaskCategory definitions
│   ├── theme/            # AppThemeData, 6 AppThemes, ThemeNotifier & InheritedWidget
│   ├── utils/            # TimeUtils & HapticsHelper
│   ├── services/         # PreferencesService & NotificationService
│   └── widgets/          # BounceTappable, CustomChip, AmbientBackground
│
├── data/
│   ├── models/           # TaskModel & FocusTimerState
│   ├── database/         # AppDatabase (SQLite schema & migrations)
│   └── repositories/     # TaskRepository (CRUD queries)
│
├── features/
│   ├── home/             # HomeHeader, CurrentTaskCard, NextTaskCard, DayProgressBar, HomeScreen
│   ├── schedule/         # DateSelectorStrip, TimelineTaskTile, ScheduleScreen
│   ├── task/             # TaskDetailSheet, AddEditTaskSheet
│   ├── timer/            # TimerRingPainter, FocusTimerScreen, FocusTimerNotifier
│   ├── settings/         # SettingsScreen & Theme switcher
│   └── navigation/       # MainScaffold (Floating capsule navigation & quick FAB)
│
└── main.dart             # App initialization, ProviderScope, and animated splash
```

---

## 🛠️ Tech Stack & Dependencies

| Layer | Library / Tool | Purpose |
|---|---|---|
| **Framework** | [Flutter 3.24+](https://flutter.dev) | Cross-platform mobile UI |
| **Language** | [Dart 3.5+](https://dart.dev) | Type-safe, high-performance logic |
| **State Management** | `flutter_riverpod` | Predictable, compile-safe state providers |
| **Persistence** | `sqflite`, `path` | Local SQLite database storage |
| **Preferences** | `shared_preferences` | Theme and user preference persistence |
| **Notifications** | `flutter_local_notifications` | Exact alarm scheduling & heads-up alerts |
| **Timezone** | `timezone`, `flutter_timezone` | Device local timezone resolution |
| **Date & Formatting** | `intl` | Robust date/time parsing and formatting |

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.24 or newer)
- Android SDK (API 34+)
- Android Studio or VS Code with Flutter extension
- USB debugging enabled on an Android device or an active emulator

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/IshtiAK47/KiKorbo.git
   cd KiKorbo
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run code quality checks:**
   ```bash
   flutter analyze
   flutter test
   ```

4. **Launch the app:**
   ```bash
   flutter run
   ```

---

## 📦 Building the Release APK

To produce a production-ready, optimized Android APK:

```bash
flutter build apk --release
```

The resulting standalone binary will be generated at:
```text
build/app/outputs/flutter-apk/app-release.apk
```

To install directly to a connected device via ADB:
```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔮 Roadmap

- [ ] Recurring daily/weekly task presets
- [ ] Android Home Screen glance widget
- [ ] Subtle custom audio completion cues
- [ ] Weekly flow and completion retrospective
- [ ] Natural language quick input (e.g. *"Gym at 5pm for 45m"*)

---

## 👤 Author

**Ishtiak Mahmood**
- GitHub: [@IshtiAK47](https://github.com/IshtiAK47)
- Repository: [https://github.com/IshtiAK47/KiKorbo.git](https://github.com/IshtiAK47/KiKorbo.git)

---

## 📄 License

This project is open-source under the [MIT License](LICENSE).
