# 🐱 Neko English

> Learn English with your adorable virtual kitty! A Flutter mobile game inspired by Pou, where you care for Neko while learning English vocabulary, completing quizzes, and having fun.

---

## 🎮 Features

### 🏠 Home Screen
- Animated kitty character drawn with pure Flutter CustomPainter
- Hunger, Happiness, Energy stat bars
- English XP progress bar with level-up system
- Coin economy
- Mood system (happy/neutral/sad/very sad)

### 🍳 Kitchen Screen
- 6 foods to buy and feed Neko (Fish, Milk, Meat, Cookie, Cake, Apple)
- English food vocabulary labels
- Coin-based economy

### ☁️ Bedroom Screen
- Sleep to restore energy
- 3 Bedtime Stories in English (tap to advance pages)
- XP reward for completing stories

### ⭐ Outdoor Screen
- 6 outdoor activities (Play Ball, Chase Butterflies, Smell Flowers, etc.)
- English activity labels
- Happiness & energy system

### 📖 Classroom Screen (3 mini-modes)
1. **Vocabulary Flashcards** — flip to reveal translations (Animals, Food, Colors, Feelings, Places)
2. **Multiple Choice Quiz** — 5 random questions, scored and explained
3. **Word Matching** — match English words to Portuguese translations

### 🌸 Park Walk Screen
- Meet 3 friends: Mochi 🐱, Daisy 🐶, Benny 🐰
- Full English dialog conversations
- XP reward for completing each interaction

### 🐾 Mini Game — Neko Run!
- Pac-Man inspired maze game
- Collect dots, avoid ghosts
- Power dots make ghosts scared
- D-pad controls
- Score converts to XP and coins

---

## 🛠️ Setup

### Requirements
- Flutter SDK 3.0+
- Android Studio or VS Code with Flutter plugin
- Android device or emulator (API 21+)

### Installation

```bash
# 1. Clone the repo
git clone https://github.com/yourusername/neko_english.git
cd neko_english

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Build APK for Android

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📁 Project Structure

```
lib/
├── main.dart                 # Entry point + splash screen
├── models/
│   └── cat_model.dart        # Cat stats, mood, XP, level
├── providers/
│   └── game_provider.dart    # State management (ChangeNotifier)
├── data/
│   └── english_data.dart     # Words, quiz questions, stories
├── widgets/
│   └── cat_widget.dart       # Animated cat + StatBar widget
└── screens/
    ├── home_screen.dart       # Main screen
    ├── kitchen_screen.dart    # Feed Neko
    ├── bedroom_screen.dart    # Sleep + Stories
    ├── outdoor_screen.dart    # Play outside
    ├── classroom_screen.dart  # Vocabulary + Quiz + Matching
    ├── walk_screen.dart       # Meet friends
    └── minigame_screen.dart   # Neko Run! (Pac-Man style)
```

---

## 🧩 Tech Stack

| Feature | Solution |
|---|---|
| State management | `provider` |
| Local storage | `shared_preferences` |
| Fonts | `google_fonts` (Pacifico + Nunito) |
| Animations | `flutter_animate` |
| Graphics | Pure Flutter `CustomPainter` |
| Networking | None — 100% offline |

---

## 🎨 Adding Your Own Cat Image

The cat is drawn with `CustomPainter` in `lib/widgets/cat_widget.dart`.  
To use a custom image instead:

1. Add your image to `assets/images/neko.png`
2. Update `pubspec.yaml` (already configured)
3. Replace `CatWidget` usage with:
```dart
Image.asset('assets/images/neko.png', width: 200)
```

---

## 💌 Made with Love

This app was created as a gift — a fun, educational experience for someone special. 🌸

*Neko says: "Study hard and I'll be happy!"* 😸
