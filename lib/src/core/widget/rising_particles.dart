import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Soft, endlessly-looping wisps that drift upward — steam over a hot dish,
/// sparkle around a plate. Cheap: a handful of blurred circles on one repeating
/// controller.
class RisingParticles extends StatefulWidget {
  final int count;
  final Color color;
  final double maxRadius;
  final Duration cycle;

  const RisingParticles({
    super.key,
    this.count = 14,
    this.color = Colors.white,
    this.maxRadius = 26,
    this.cycle = const Duration(seconds: 6),
  });

  @override
  State<RisingParticles> createState() => _RisingParticlesState();
}

class _RisingParticlesState extends State<RisingParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final List<_P> _p;

  @override
  void initState() {
    super.initState();
    final rnd = math.Random(7);
    _p = List.generate(
      widget.count,
      (_) => _P(
        x: rnd.nextDouble(),
        offset: rnd.nextDouble(),
        speed: 0.6 + rnd.nextDouble() * 0.8,
        sway: 0.04 + rnd.nextDouble() * 0.10,
        scale: 0.5 + rnd.nextDouble() * 0.9,
        phase: rnd.nextDouble() * math.pi * 2,
      ),
    );
    _c = AnimationController(vsync: this, duration: widget.cycle)..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, __) => CustomPaint(
            size: Size.infinite,
            painter: _SteamPainter(
                t: _c.value, particles: _p, color: widget.color, maxR: widget.maxRadius),
          ),
        ),
      ),
    );
  }
}

class _P {
  final double x, offset, speed, sway, scale, phase;
  _P({
    required this.x,
    required this.offset,
    required this.speed,
    required this.sway,
    required this.scale,
    required this.phase,
  });
}

class _SteamPainter extends CustomPainter {
  final double t;
  final List<_P> particles;
  final Color color;
  final double maxR;

  _SteamPainter({
    required this.t,
    required this.particles,
    required this.color,
    required this.maxR,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final life = (t * p.speed + p.offset) % 1.0;
      final y = size.height * (1.0 - life);
      final x = size.width *
          (p.x + math.sin(p.phase + life * math.pi * 2) * p.sway);
      // fade in then out across its rise
      final opacity = (math.sin(life * math.pi)) * 0.28;
      final r = maxR * p.scale * (0.4 + life * 0.9);
      final paint = Paint()
        ..color = color.withValues(alpha: opacity.clamp(0.0, 1.0))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.7);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(_SteamPainter old) => old.t != t;
}
