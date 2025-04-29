# 📦 dial_timer

[🇺🇸 English](./README.md) | [🇰🇷 한국어](./README.KO.md)

Flutter용 아름다운 원형 다이얼 타이머 위젯입니다.

원형 다이얼 UI를 드래그하여 간편하게 분(minute) 단위 시간을 선택할 수 있습니다.

---

## 🚀 Installation

`pubspec.yaml` 파일에 다음을 추가하세요:

```yaml
dependencies:
  dial_timer: ^0.0.1
```

## 사용법

```dart
import 'package:dial_timer/dial_timer.dart';

CircularTimer(
  onMinutesChanged: (minutes) {
    print('$minutes 분이 선택되었습니다.');
  },
)
```

## ✨ 주요 기능
- 원형 드래그 타이머 UI
- 1분 ~ 60분 간편 선택
- 드래그 가능 여부 설정 지원
- 쉬는 시간 모드 스타일링 (isBreakTime: true)

## 📂 예제
example/ 폴더에 전체 작동 예제가 제공됩니다.

```shell
cd example
flutter run
```