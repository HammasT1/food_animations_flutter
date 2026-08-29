import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A checkmark that draws itself: the ring sweeps around, the tick strokes on
/// with a slight overshoot, then a halo pulses outward. Purely custom-painted.
class AnimatedCheckmark extends StatefulWidget {
  final double size;
  final Color color;
  final Color ringColor;
  final Duration duration;
  final VoidCallback? onDone;

  const AnimatedCheckmark({
    super.key,
    this.size = 120,
    this.color = const Color(0xff0FA958),
    this.ringColor = const Color(0xff0FA958),
    this.duration = const Duration(milliseconds: 1100),
    this.onDone,
  });

  @override
  State<AnimatedCheckmark> createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) widget.onDone?.call();
      });
    WidgetsBinding.instance.addPostFrameCallback((_) => _c.forward());
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => CustomPaint(
          painter: _CheckmarkPainter(
            progress: _c.value,
            color: widget.color,
            ringColor: widget.ringColor,
          ),
        ),
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color ringColor;

  _CheckmarkPainter({
    required this.progress,
    required this.color,
    required this.ringColor,
  });

  double _seg(double start, double end) =>
      ((progress - start) / (end - start)).clamp(0.0, 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * 0.42;

    // ---- 1. ring sweeps in (0 → .45) ----
    final ringT = Curves.easeOutCubic.transform(_seg(0.0, 0.45));
    if (ringT > 0) {
      final ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.055
        ..strokeCap = StrokeCap.round
        ..color = ringColor;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * ringT,
        false,
        ringPaint,
      );
    }

    // ---- 2. filled disc fades/pops in (.35 → .6) ----
    final discT = Curves.easeOutBack.transform(_seg(0.35, 0.62));
    if (discT > 0) {
      canvas.drawCircle(
        center,
        radius * discT,
        Paint()..color = color,
      );
    }

    // ---- 3. tick strokes on (.45 → .8) ----
    final tickT = Curves.easeOutCubic.transform(_seg(0.45, 0.82));
    if (tickT > 0) {
      final p1 = Offset(size.width * 0.30, size.height * 0.52);
      final p2 = Offset(size.width * 0.44, size.height * 0.66);
      final p3 = Offset(size.width * 0.72, size.height * 0.36);

      final tick = Path()..moveTo(p1.dx, p1.dy);
      const firstLegShare = 0.4;
      if (tickT <= firstLegShare) {
        final l = tickT / firstLegShare;
        tick.lineTo(
            p1.dx + (p2.dx - p1.dx) * l, p1.dy + (p2.dy - p1.dy) * l);
      } else {
        tick.lineTo(p2.dx, p2.dy);
        final l = (tickT - firstLegShare) / (1 - firstLegShare);
        tick.lineTo(
            p2.dx + (p3.dx - p2.dx) * l, p2.dy + (p3.dy - p2.dy) * l);
      }

      canvas.drawPath(
        tick,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.075
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = Colors.white,
      );
    }

    // ---- 4. halo pulse (.7 → 1) ----
    final haloT = _seg(0.7, 1.0);
    if (haloT > 0 && haloT < 1) {
      canvas.drawCircle(
        center,
        radius * (1 + haloT * 1.1),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.04 * (1 - haloT)
          ..color = ringColor.withValues(alpha: (1 - haloT) * 0.6),
      );
    }
  }

  @override
  bool shouldRepaint(_CheckmarkPainter old) =>
      old.progress != progress || old.color != color;
}
