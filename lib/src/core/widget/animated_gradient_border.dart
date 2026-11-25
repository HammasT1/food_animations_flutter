import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A slowly rotating sweep-gradient ring (plus a soft glow) drawn around
/// [child]. Fades in when [active] turns on, and out when it turns off.
class AnimatedGradientBorder extends StatefulWidget {
  final Widget child;
  final bool active;
  final BorderRadius borderRadius;
  final List<Color> colors;
  final double width;
  final Duration period;

  const AnimatedGradientBorder({
    super.key,
    required this.child,
    required this.colors,
    this.active = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.width = 2,
    this.period = const Duration(seconds: 4),
  });

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin =
      AnimationController(vsync: this, duration: widget.period);

  @override
  void initState() {
    super.initState();
    if (widget.active) _spin.repeat();
  }

  @override
  void didUpdateWidget(AnimatedGradientBorder old) {
    super.didUpdateWidget(old);
    // only tick while visible — no idle repaints on unselected items
    if (widget.active && !_spin.isAnimating) _spin.repeat();
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: widget.active ? 1 : 0),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOut,
      onEnd: () {
        if (!widget.active) _spin.stop();
      },
      builder: (context, opacity, child) => AnimatedBuilder(
        animation: _spin,
        builder: (context, child) => CustomPaint(
          foregroundPainter: opacity == 0
              ? null
              : _SweepBorderPainter(
                  rotation: _spin.value * 2 * math.pi,
                  opacity: opacity,
                  colors: widget.colors,
                  borderRadius: widget.borderRadius,
                  width: widget.width,
                ),
          child: child,
        ),
        child: child,
      ),
      child: widget.child,
    );
  }
}

class _SweepBorderPainter extends CustomPainter {
  final double rotation;
  final double opacity;
  final List<Color> colors;
  final BorderRadius borderRadius;
  final double width;

  _SweepBorderPainter({
    required this.rotation,
    required this.opacity,
    required this.colors,
    required this.borderRadius,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect).deflate(width / 2);
    final shader = SweepGradient(
      colors: [
        for (final c in [...colors, colors.first])
          c.withValues(alpha: c.a * opacity),
      ],
      transform: GradientRotation(rotation),
    ).createShader(rect);

    // soft bloom under the crisp ring
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width * 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
        ..shader = shader,
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..shader = shader,
    );
  }

  @override
  bool shouldRepaint(_SweepBorderPainter old) =>
      old.rotation != rotation ||
      old.opacity != opacity ||
      old.colors != colors;
}
