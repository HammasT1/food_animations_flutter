import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A one-shot confetti burst. Drops [count] paper bits from an origin with
/// randomised velocity, gravity, spin and flutter, then fades them out.
class ConfettiOverlay extends StatefulWidget {
  final int count;
  final Duration duration;
  final Alignment origin;
  final List<Color> colors;

  const ConfettiOverlay({
    super.key,
    this.count = 90,
    this.duration = const Duration(milliseconds: 2200),
    this.origin = const Alignment(0, -0.15),
    this.colors = const [
      Color(0xffFFC107),
      Color(0xffFF5252),
      Color(0xff40C4FF),
      Color(0xff69F0AE),
      Color(0xffE040FB),
      Colors.white,
    ],
  });

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final List<_Bit> _bits;

  @override
  void initState() {
    super.initState();
    final rnd = math.Random();
    _bits = List.generate(widget.count, (_) {
      final angle = -math.pi / 2 + (rnd.nextDouble() - 0.5) * math.pi * 1.15;
      final speed = 0.55 + rnd.nextDouble() * 1.15;
      return _Bit(
        velocity: Offset(math.cos(angle), math.sin(angle)) * speed,
        color: widget.colors[rnd.nextInt(widget.colors.length)],
        size: 5 + rnd.nextDouble() * 8,
        spin: (rnd.nextDouble() - 0.5) * 14,
        phase: rnd.nextDouble() * math.pi * 2,
        round: rnd.nextBool(),
        drift: (rnd.nextDouble() - 0.5) * 0.4,
      );
    });
    _c = AnimationController(vsync: this, duration: widget.duration)..forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(
            t: _c.value,
            bits: _bits,
            origin: widget.origin,
          ),
        ),
      ),
    );
  }
}

class _Bit {
  final Offset velocity;
  final Color color;
  final double size;
  final double spin;
  final double phase;
  final bool round;
  final double drift;
  _Bit({
    required this.velocity,
    required this.color,
    required this.size,
    required this.spin,
    required this.phase,
    required this.round,
    required this.drift,
  });
}

class _ConfettiPainter extends CustomPainter {
  final double t;
  final List<_Bit> bits;
  final Alignment origin;

  _ConfettiPainter({required this.t, required this.bits, required this.origin});

  @override
  void paint(Canvas canvas, Size size) {
    final start = origin.alongSize(size);
    final spread = size.shortestSide * 1.15;
    final gravity = size.height * 0.9;
    final fade = (1 - ((t - 0.7) / 0.3)).clamp(0.0, 1.0);

    for (final b in bits) {
      final pos = start +
          b.velocity * spread * t +
          Offset(math.sin(b.phase + t * 8) * 18 + b.drift * spread * t,
              0.5 * gravity * t * t);

      final paint = Paint()..color = b.color.withValues(alpha: fade);
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(b.phase + b.spin * t);
      final s = b.size;
      if (b.round) {
        canvas.drawCircle(Offset.zero, s / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: s, height: s * 0.55),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
