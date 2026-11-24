<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=12,20,24&height=230&section=header&text=Food%20Animation&fontSize=64&fontColor=ffffff&animation=twinkling&fontAlignY=36&desc=A%20motion-first%20recipe%20%26%20ordering%20app%20built%20with%20Flutter&descAlignY=58&descSize=18" alt="Food Animation banner" width="100%"/>

<a href="#-highlights">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=20&duration=2800&pause=900&color=FF7043&center=true&vCenter=true&width=680&lines=Kinetic+onboarding+%F0%9F%8D%BD%EF%B8%8F;Staggered+3D+card+reveals+%F0%9F%83%8F;Hero+flights+%26+custom+painters+%F0%9F%8E%A8;Odometer+prices+%26+flipping+cards+%F0%9F%92%B3;A+pay+button+that+blooms+into+success+%F0%9F%8E%89" alt="Animated feature list"/>
</a>

<br/><br/>

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/State-Riverpod-40C4FF?style=for-the-badge)](https://riverpod.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-2ea44f?style=for-the-badge)](LICENSE)

[![Release APK](https://img.shields.io/github/actions/workflow/status/HammasT1/food_animations_flutter/release.yml?style=flat-square&label=release%20build&logo=githubactions&logoColor=white)](https://github.com/HammasT1/food_animations_flutter/actions/workflows/release.yml)
[![Latest release](https://img.shields.io/github/v/release/HammasT1/food_animations_flutter?style=flat-square&color=FF7043&logo=android&logoColor=white)](https://github.com/HammasT1/food_animations_flutter/releases/latest)
[![Stars](https://img.shields.io/github/stars/HammasT1/food_animations_flutter?style=flat-square&color=FFC107&logo=github)](https://github.com/HammasT1/food_animations_flutter/stargazers)
[![Last commit](https://img.shields.io/github/last-commit/HammasT1/food_animations_flutter?style=flat-square&color=8E24AA)](https://github.com/HammasT1/food_animations_flutter/commits/main)

![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=flat-square&logo=apple&logoColor=white)
![Web](https://img.shields.io/badge/Web-4285F4?style=flat-square&logo=googlechrome&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black)
![macOS](https://img.shields.io/badge/macOS-000000?style=flat-square&logo=macos&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=flat-square&logo=windows&logoColor=white)

<br/>

<a href="https://github.com/HammasT1/food_animations_flutter/releases/latest">
  <img src="https://img.shields.io/badge/%E2%AC%87%EF%B8%8F%20Download%20APK-FF7043?style=for-the-badge&logoColor=white" alt="Download APK" height="40"/>
</a>

<p>
  <a href="#-about">About</a> •
  <a href="#-highlights">Highlights</a> •
  <a href="#-animation-catalog">Animation Catalog</a> •
  <a href="#-user-flow">User Flow</a> •
  <a href="#-tech-stack">Tech Stack</a> •
  <a href="#-getting-started">Getting Started</a> •
  <a href="#-project-structure">Structure</a>
</p>

</div>

<img src="assets/readme/divider.svg" alt="" width="100%"/>

## 📖 About

<table>
  <tr>
    <td width="320" align="center" valign="top">
      <img src="assets/food_animations-flutter.gif" alt="Food Animation app preview" width="280"/>
      <br/>
      <sub>Onboarding → Home → Details → Checkout → Payment → Success</sub>
    </td>
    <td valign="top">

**Food Animation** is a Flutter recipe and food-ordering app built to show what
a polished, motion-first UI can feel like.

Every screen has a signature animation, built with
[`flutter_animate`](https://pub.dev/packages/flutter_animate) and hand-rolled
`CustomPainter`s. **No heavyweight animation packages, no Lottie.**

#### At a glance

- 🎬 **6 screens**, each with its own signature motion
- 🧩 **9 reusable animation primitives** in `lib/src/core/widget`
- 🎨 **Custom painters** for checkmark, confetti, steam & dashed rules
- 📳 **Haptic feedback** on key interactions
- 🌗 **Material 3** theming via `flex_color_scheme`
- 📦 **Automated APK releases** through GitHub Actions

    </td>
  </tr>
</table>

<img src="assets/readme/divider.svg" alt="" width="100%"/>

## ✨ Highlights

<table>
  <tr>
    <td width="170"><b>🚀 Onboarding</b></td>
    <td>The dish pops in with an elastic spin, garnish flies in and sways forever, black pepper shakes, and a word-by-word kinetic headline plays above a glowing, breathing call-to-action. Tapping it dives <i>through</i> the plate into the app.</td>
  </tr>
  <tr>
    <td><b>🏠 Home</b></td>
    <td>Recipe cards fall onto the table one by one in real perspective (<code>rotateX</code>), de-blurring as they land. Avatar with a pulsing halo, spring-loaded category chips, drifting steam over the hero dish.</td>
  </tr>
  <tr>
    <td><b>🍳 Recipe Details</b></td>
    <td>The hero image flies in from the card and settles into a slow rotisserie hover. The stat row <b>counts up</b> from zero, and timeline dots pop in with an elastic bounce while the connector line draws itself downward.</td>
  </tr>
  <tr>
    <td><b>🧾 Checkout</b></td>
    <td>Bill totals <b>roll</b> like an odometer when the quantity changes, with a springy stepper, haptics and a perforated dashed receipt edge.</td>
  </tr>
  <tr>
    <td><b>💳 Payment</b></td>
    <td>A glossy card <b>flips on its Y-axis</b> to match the selected method (Visa / Apple Pay / PayPal / Cash), each with its own gradient. Method cards flip up in 3D as they stagger in.</td>
  </tr>
  <tr>
    <td><b>🎉 Success</b></td>
    <td>The <b>morphing pay button</b> collapses into a coin, spins a loader, then balloons out to fill the screen and hands off to a success screen with a self-drawing checkmark and a confetti burst.</td>
  </tr>
</table>

<img src="assets/readme/divider.svg" alt="" width="100%"/>

## 🎞️ Animation Catalog

The reusable building blocks behind the motion, and where to find them.

| Effect | Technique | Source |
| --- | --- | --- |
| ✅ Self-drawing checkmark | Ring sweep, overshooting tick & halo pulse (`CustomPainter`) | [`animated_checkmark.dart`](lib/src/core/widget/animated_checkmark.dart) |
| 🎊 Confetti burst | Randomised velocity, gravity, spin & flutter (`CustomPainter`) | [`confetti_overlay.dart`](lib/src/core/widget/confetti_overlay.dart) |
| ♨️ Rising steam | Blurred wisps on one repeating controller | [`rising_particles.dart`](lib/src/core/widget/rising_particles.dart) |
| 💰 Morphing pay button | Pill → coin → loader → full-screen bloom | [`morphing_pay_button.dart`](lib/src/core/widget/morphing_pay_button.dart) |
| 🔢 Odometer prices | Tweened currency value that rolls between amounts | [`animated_price.dart`](lib/src/core/widget/animated_price.dart) |
| 📈 Count-up stats | Tweened numeric counters | [`animated_count.dart`](lib/src/core/widget/animated_count.dart) |
| 🌟 Breathing glow | Pulsing radial backdrop | [`glow_backdrop.dart`](lib/src/core/widget/glow_backdrop.dart) |
| ✂️ Perforated receipt edge | Dashed-line painter | [`dashed_divider.dart`](lib/src/core/widget/dashed_divider.dart) |
| 🧭 Route transitions | Slide-up & shared-axis `PageRouteBuilder`s | [`page_transition.dart`](lib/src/core/animation/page_transition.dart) |

<img src="assets/readme/divider.svg" alt="" width="100%"/>

## 🧭 User Flow

```mermaid
flowchart LR
    A([🚀 Onboarding]) -->|dive through the plate| B([🏠 Home])
    B -->|hero flight| C([🍳 Recipe Details])
    C --> D([🧾 Checkout])
    D -->|shared-axis| E([💳 Payment])
    E -->|morphing pay button| F([🎉 Success])

    classDef screen fill:#FF7043,stroke:#BF360C,color:#ffffff,stroke-width:2px;
    class A,B,C,D,E,F screen;
```

<img src="assets/readme/divider.svg" alt="" width="100%"/>

## 🧱 Tech Stack

<div align="center">

<img src="https://skillicons.dev/icons?i=flutter,dart,androidstudio,vscode,githubactions,linux&theme=dark" alt="Tech stack icons"/>

</div>

<br/>

| Area | Tools |
| --- | --- |
| **Framework** | Flutter (Material 3, Impeller renderer) |
| **State management** | [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod) |
| **Animation** | [`flutter_animate`](https://pub.dev/packages/flutter_animate) + custom `CustomPainter`s |
| **Models** | `freezed` + `json_serializable` |
| **Theming** | [`flex_color_scheme`](https://pub.dev/packages/flex_color_scheme) |
| **UI** | [`sliding_up_panel`](https://pub.dev/packages/sliding_up_panel) for the recipe-steps sheet |
| **Tooling** | `build_runner`, `flutter_lints`, `riverpod_lint`, `device_preview` |
| **CI/CD** | GitHub Actions: builds and publishes a release APK on every `v*` tag |

<img src="assets/readme/divider.svg" alt="" width="100%"/>

## 🚀 Getting Started

### Prerequisites

- Flutter SDK **3.x** (Dart 3). Run `flutter doctor` and resolve any issues.
- An Android emulator, iOS simulator, desktop target or a physical device.

### Run

```bash
# 1. Clone
git clone https://github.com/HammasT1/food_animations_flutter.git
cd food_animations_flutter

# 2. Install dependencies
flutter pub get

# 3. (Optional) regenerate model code
dart run build_runner build --delete-conflicting-outputs

# 4. Launch
flutter run
```

> [!TIP]
> Just want to try it? Grab the latest APK from the
> [**Releases**](https://github.com/HammasT1/food_animations_flutter/releases/latest) page.

<details>
<summary><b>📦 Cutting a release</b></summary>

<br/>

The [`Release APK`](.github/workflows/release.yml) workflow builds a release APK
and attaches it to a GitHub Release. Trigger it either way:

```bash
# Option 1: push a tag
git tag v1.0.0 && git push origin v1.0.0

# Option 2: Actions ▸ "Release APK" ▸ Run workflow ▸ version = 1.0.0
```

</details>

<details>
<summary><b>🪟 Windows build note</b></summary>

<br/>

If the Android build fails with a Kotlin
`"this and base files have different roots"` error, keep the project and the
Dart pub cache on the **same drive**. The provided `android/gradle.properties`
flag (`kotlin.incremental=false`) also works around it.

</details>

<img src="assets/readme/divider.svg" alt="" width="100%"/>

## 🗂️ Project Structure

```text
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

<img src="assets/readme/divider.svg" alt="" width="100%"/>

## 🤝 Contributing

Issues and pull requests are welcome. For larger changes, please open an issue
first to discuss what you would like to change.

1. Fork the repo
2. Create a branch: `git checkout -b feature/my-feature`
3. Commit your changes and push the branch
4. Open a pull request

## 📄 License

Released under the [MIT License](LICENSE).

<div align="center">

<br/>

<sub>Recipe imagery is used for demonstration purposes only.</sub>

<br/><br/>

<a href="https://github.com/HammasT1/food_animations_flutter/stargazers">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=500&size=16&duration=3000&pause=1200&color=FF7043&center=true&vCenter=true&width=460&lines=%E2%AD%90+If+you+like+this+project%2C+give+it+a+star!;Made+with+%F0%9F%A7%A1+and+Flutter" alt="Star the repo"/>
</a>

<img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=12,20,24&height=110&section=footer&animation=twinkling" alt="" width="100%"/>

</div>
