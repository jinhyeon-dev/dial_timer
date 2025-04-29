# 📦 dial_timer

[🇺🇸 English](./README.md) | [🇰🇷 한국어](./README.KO.md)

A beautiful circular dial timer widget for Flutter.

Easily select a time (in minutes) by dragging around a circular dial UI.

---

## 🚀 Installation

Add the following line to your `pubspec.yaml`:

```yaml
dependencies:
  dial_timer: ^0.0.1
```

## Usage

```dart
import 'package:dial_timer/dial_timer.dart';

CircularTimer(
  onMinutesChanged: (minutes) {
    print('$minutes minutes selected');
  },
)
```

## ✨ Features
- Circular draggable timer UI
- Select from 1 to 60 minutes easily
- Customize draggable ability
- Break time mode styling (isBreakTime: true)

## 📂 Example
A full working example is available in the example/ folder.

```shell
cd example
flutter run
```