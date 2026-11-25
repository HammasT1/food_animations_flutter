import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension ShineSweep on Widget {
  /// A diagonal band of light that glides across the widget every
  /// [interval] — a quiet "tap me" cue for primary buttons.
  Widget shineSweep({
    Duration interval = const Duration(milliseconds: 3200),
    Duration startDelay = const Duration(milliseconds: 1500),
    double strength = 0.55,
  }) {
    return animate(delay: startDelay, onPlay: (c) => c.repeat()).shimmer(
      delay: interval,
      duration: 1100.ms,
      curve: Curves.easeInOutSine,
      angle: 0.45,
      color: Colors.white.withValues(alpha: strength),
    );
  }
}
