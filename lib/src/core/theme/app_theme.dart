import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Font families bundled in `assets/fonts` (see pubspec.yaml).
abstract final class AppFonts {
  /// High-contrast editorial serif for headlines, dish names and prices.
  /// Ships in a single weight — never bold it, or Flutter fakes the weight.
  static const display = 'DMSerifDisplay';

  /// Clean geometric sans for UI and body copy.
  static const body = 'Manrope';
}

const _display = TextStyle(
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);

final _textTheme = TextTheme(
  // onboarding headline
  displaySmall:
      _display.copyWith(fontSize: 42, height: 1.05, letterSpacing: -0.8),
  // greeting + screen titles
  headlineMedium:
      _display.copyWith(fontSize: 34, height: 1.1, letterSpacing: -0.6),
  // dish names, section counts, totals
  titleLarge:
      _display.copyWith(fontSize: 23, height: 1.15, letterSpacing: -0.3),
  titleMedium: const TextStyle(
      color: Colors.white,
      height: 1.4,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.1),
  titleSmall: const TextStyle(
      fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: -0.1),
  bodyLarge: const TextStyle(
      color: Colors.black,
      height: 1.4,
      fontSize: 17,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.1),
  bodySmall: const TextStyle(
      fontSize: 13.5,
      height: 1.45,
      color: Colors.white60,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1),
  // small caps-style overlines (nutrition tags)
  labelMedium: TextStyle(
      fontSize: 11,
      color: Colors.amber.shade100,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2),
  labelLarge: const TextStyle(
      fontSize: 12.5,
      height: 1.45,
      color: Colors.white60,
      fontWeight: FontWeight.w500),
);

final _base = FlexThemeData.dark(fontFamily: AppFonts.body);

final mainTheme = _base.copyWith(
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
    textTheme: _base.textTheme.merge(_textTheme),
    cardTheme: CardThemeData(
        color: AppColors.cardColor,
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))));
