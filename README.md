<div align="center">

# 🍽️ Food Animation

### A Flutter recipe & food‑ordering app built as a showcase for high‑impact motion design

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/State-Riverpod-40C4FF)](https://riverpod.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-lightgrey)]()

Kinetic onboarding · staggered 3D card reveals · hero flights · custom‑painted particle systems ·
a morphing pay button that blooms into a colour‑matched success screen.

</div>

---

## ✨ Highlights

| Screen | What makes it move |
| --- | --- |
| **Onboarding** | Dish pops in with an elastic spin, garnish flies in and sways forever, black pepper shakes, a word‑by‑word kinetic headline, and a glowing, breathing call‑to‑action. Tapping it dives *through* the plate into the app. |
| **Home** | Recipe cards fall onto the table one by one in real perspective (`rotateX`), de‑blurring as they land. Avatar with a pulsing halo, spring‑loaded category chips, drifting steam over the hero dish. |
| **Recipe Details** | Hero image flies in from the card and settles into a slow rotisserie hover, stat row **counts up** from zero, timeline dots pop in with an elastic bounce while the connector line draws itself downward. |
| **Checkout** | Bill totals **roll** like an odometer whenever the quantity changes, a springy stepper with haptics, a perforated dashed receipt edge. |
| **Payment** | A glossy card **flips on its Y‑axis** to match the selected method (Visa / Apple Pay / PayPal / Cash), each with its own gradient. Method cards flip up in 3D as they stagger in. |
| **Payment Success** | The **morphing pay button** collapses into a coin, spins a loader, then balloons out to fill the screen and hands off seamlessly to a success screen with a self‑drawing checkmark and a confetti burst. |

All effects are built with [`flutter_animate`](https://pub.dev/packages/flutter_animate) and hand‑rolled
`CustomPainter`s — no heavyweight animation packages, no Lottie.

---

## 📸 Screenshots & GIFs

> _Coming soon._

<!--
| Onboarding | Home | Details |
| :---: | :---: | :---: |
| <img src="docs/onboarding.gif" width="220"/> | <img src="docs/home.gif" width="220"/> | <img src="docs/details.gif" width="220"/> |

| Checkout | Payment | Success |
| :---: | :---: | :---: |
| <img src="docs/checkout.png" width="220"/> | <img src="docs/payment.gif" width="220"/> | <img src="docs/success.gif" width="220"/> |
-->

---

## 🧱 Tech Stack

- **Flutter** (Material 3, Impeller renderer)
- **flutter_riverpod** — state management
- **flutter_animate** — declarative effect chains
- **freezed** + **json_serializable** — immutable models & JSON parsing
- **flex_color_scheme** — theming
- **sliding_up_panel** — the recipe‑steps sheet
- Custom `CustomPainter`s for the checkmark, confetti, steam and dashed rules

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK **3.x** (Dart 3) — run `flutter doctor` and resolve any issues
- An Android emulator / iOS simulator or a physical device

### Run

```bash
# 1. Install dependencies
flutter pub get

# 2. (Optional) regenerate model code
dart run build_runner build --delete-conflicting-outputs

# 3. Launch
flutter run
```

> **Windows note:** if the Android build fails with a Kotlin
> `"this and base files have different roots"` error, keep the project and the
> Dart pub cache on the **same drive**, or the provided
> `android/gradle.properties` flags (`kotlin.incremental=false`) will work around it.

---

## 🗂️ Project Structure

```
lib/
├─ main.dart                     # app entry, routes & page transitions
└─ src/
   ├─ core/
   │  ├─ animation/              # shared route transitions
   │  ├─ theme/                  # colors + Material 3 theme
   │  └─ widget/                 # reusable animation primitives
   │     ├─ animated_checkmark.dart
   │     ├─ confetti_overlay.dart
   │     ├─ rising_particles.dart
   │     ├─ morphing_pay_button.dart
   │     ├─ animated_price.dart / animated_count.dart
   │     └─ glow_backdrop.dart / dashed_divider.dart
   ├─ onboarding/                # animated onboarding screen
   ├─ recipes/                   # home list + recipe details (data / domain / presentation)
   └─ checkout/                  # checkout → payment method → payment success
```

---

## 📄 License

Released under the [MIT License](LICENSE).

<div align="center">
<sub>Recipe imagery is used for demonstration purposes only.</sub>
</div>
