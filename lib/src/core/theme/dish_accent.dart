import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:dribbble_challenge/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The signature colour of a dish, pulled from its photo. Cached per asset,
/// so every screen showing the same dish shares one accent.
final dishAccentProvider =
    FutureProvider.family<Color, String>((ref, asset) => extractAccent(asset));

/// Accent for [asset], falling back to the brand amber while it's computed.
Color watchDishAccent(WidgetRef ref, String asset) =>
    ref.watch(dishAccentProvider(asset)).valueOrNull ??
    AppColors.onBoardingButtonColor;

/// Readable foreground (black/white) for text placed on [color].
Color onAccent(Color color) =>
    ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black;

/// A pale tint of [color] for small text on dark surfaces.
Color softAccent(Color color) => Color.lerp(color, Colors.white, 0.45)!;

/// Finds the dominant *vivid* hue of an image: samples a thumbnail, ignores
/// transparent, grey, near-black, near-white and blue pixels (plates, bowls,
/// backgrounds), buckets the rest by hue weighted by vividness, and returns
/// the heaviest bucket's average — normalised into a bright accent.
Future<Color> extractAccent(String asset) async {
  const fallback = AppColors.onBoardingButtonColor;
  try {
    final data = await rootBundle.load(asset);
    // The codec's resize samples single pixels (a crouton, a cheese
    // highlight), so decode larger and box-average 4×4 blocks ourselves to
    // get each region's true overall colour.
    const block = 4;
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 48 * block,
    );
    final frame = await codec.getNextFrame();
    final width = frame.image.width;
    final height = frame.image.height;
    // note: rawRgba is alpha-premultiplied
    final pixels =
        await frame.image.toByteData(format: ui.ImageByteFormat.rawRgba);
    frame.image.dispose();
    codec.dispose();
    if (pixels == null) return fallback;

    // 30° hue buckets: wide enough that a dish's tones pool together
    const bins = 12;
    final weight = List<double>.filled(bins, 0);
    final rs = List<double>.filled(bins, 0);
    final gs = List<double>.filled(bins, 0);
    final bs = List<double>.filled(bins, 0);

    for (var by = 0; by + block <= height; by += block) {
      for (var bx = 0; bx + block <= width; bx += block) {
        var sr = 0, sg = 0, sb = 0, sa = 0;
        for (var y = by; y < by + block; y++) {
          for (var x = bx; x < bx + block; x++) {
            final i = (y * width + x) * 4;
            sr += pixels.getUint8(i);
            sg += pixels.getUint8(i + 1);
            sb += pixels.getUint8(i + 2);
            sa += pixels.getUint8(i + 3);
          }
        }
        if (sa / (block * block) < 200) continue;
        // un-premultiply the averaged block
        final r = (sr * 255 / sa).round().clamp(0, 255);
        final g = (sg * 255 / sa).round().clamp(0, 255);
        final b = (sb * 255 / sa).round().clamp(0, 255);
        final hsv = HSVColor.fromColor(Color.fromARGB(255, r, g, b));
        if (hsv.saturation < 0.25 || hsv.value < 0.3) continue;
        // blue–violet is almost never the food itself — it's plates & bowls
        if (hsv.hue >= 190 && hsv.hue <= 280) continue;
        // chroma^1.5: vivid pixels count more, but a big area of a softer
        // colour (lettuce, saffron rice) can still win
        final w = math.pow(hsv.saturation * hsv.value, 1.5).toDouble();
        final bin = (hsv.hue / 360 * bins).floor() % bins;
        weight[bin] += w;
        rs[bin] += r * w;
        gs[bin] += g * w;
        bs[bin] += b * w;
      }
    }

    var best = 0;
    for (var i = 1; i < bins; i++) {
      if (weight[i] > weight[best]) best = i;
    }
    if (weight[best] == 0) return fallback;

    final w = weight[best];
    final avg = Color.fromARGB(255, (rs[best] / w).round(),
        (gs[best] / w).round(), (bs[best] / w).round());
    final hsl = HSLColor.fromColor(avg);
    return hsl
        .withSaturation(math.max(hsl.saturation, 0.65))
        .withLightness(hsl.lightness.clamp(0.55, 0.64))
        .toColor();
  } catch (_) {
    return fallback;
  }
}
