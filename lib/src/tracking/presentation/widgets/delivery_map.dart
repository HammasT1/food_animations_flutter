import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:dribbble_challenge/src/core/theme/dish_accent.dart';
import 'package:dribbble_challenge/src/core/widget/rising_particles.dart';
import 'package:dribbble_challenge/src/tracking/domain/delivery_stage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Route waypoints in unit space, following the street grid below.
const _waypoints = [
  Offset(0.14, 0.80),
  Offset(0.38, 0.80),
  Offset(0.38, 0.52),
  Offset(0.66, 0.52),
  Offset(0.66, 0.24),
  Offset(0.86, 0.24),
];
const _avenuesX = [0.14, 0.38, 0.66, 0.86];
const _streetsY = [0.24, 0.52, 0.80];

/// Total simulated route length, for the "x km away" pill.
const _routeKm = 3.4;

/// The delivery route as a path with rounded corners.
Path _routePath(Size size, {double corner = 16}) {
  final pts = [
    for (final p in _waypoints) Offset(p.dx * size.width, p.dy * size.height)
  ];
  final path = Path()..moveTo(pts.first.dx, pts.first.dy);
  for (var i = 1; i < pts.length - 1; i++) {
    final prev = pts[i - 1], cur = pts[i], next = pts[i + 1];
    final inDir = (cur - prev) / (cur - prev).distance;
    final outDir = (next - cur) / (next - cur).distance;
    final a = cur - inDir * corner;
    final b = cur + outDir * corner;
    path
      ..lineTo(a.dx, a.dy)
      ..quadraticBezierTo(cur.dx, cur.dy, b.dx, b.dy);
  }
  return path..lineTo(pts.last.dx, pts.last.dy);
}

/// A stylised, hand-drawn city map with the rider travelling the route.
class DeliveryMap extends StatelessWidget {
  /// 0..1 — how far along the route the rider is.
  final double progress;
  final DeliveryStage stage;
  final Color accent;

  const DeliveryMap({
    super.key,
    required this.progress,
    required this.stage,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final size = Size(c.maxWidth, c.maxHeight);
      final metric = _routePath(size).computeMetrics().first;
      final rider =
          metric.getTangentForOffset(metric.length * progress)!.position;
      final start = Offset(
          _waypoints.first.dx * size.width, _waypoints.first.dy * size.height);
      final end = Offset(
          _waypoints.last.dx * size.width, _waypoints.last.dy * size.height);
      final delivered = stage == DeliveryStage.delivered;
      final moving = stage == DeliveryStage.onTheWay;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          // static city layer — painted once
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(painter: _CityPainter()),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _RoutePainter(progress: progress, accent: accent),
            ),
          ),
          // steam over the kitchen while it cooks
          if (stage == DeliveryStage.preparing)
            Positioned(
              left: start.dx - 30,
              top: start.dy - 78,
              width: 60,
              height: 64,
              child: RisingParticles(
                  count: 6,
                  maxRadius: 10,
                  color: Color.lerp(accent, Colors.white, 0.6)!),
            ),
          _at(
            start,
            _Pin(
              icon: Icons.storefront_rounded,
              color: accent,
              pulse: stage == DeliveryStage.preparing,
            ),
          ),
          _at(
            end,
            _Pin(
              icon: delivered ? Icons.check_rounded : Icons.home_rounded,
              color: delivered ? const Color(0xff0FA958) : Colors.white,
              pulse: moving,
              pulseColor: accent,
            ),
          ),
          if (moving)
            _at(
              rider,
              _Rider(
                accent: accent,
                kmLeft: _routeKm * (1 - progress),
              ),
            ),
        ],
      );
    });
  }

  Widget _at(Offset p, Widget child, {double box = 120}) => Positioned(
        left: p.dx - box / 2,
        top: p.dy - box / 2,
        width: box,
        height: box,
        child: Center(child: child),
      );
}

class _Pin extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool pulse;
  final Color? pulseColor;

  const _Pin({
    required this.icon,
    required this.color,
    this.pulse = false,
    this.pulseColor,
  });

  @override
  Widget build(BuildContext context) {
    final ring = pulseColor ?? color;
    return Stack(
      alignment: Alignment.center,
      children: [
        if (pulse)
          for (var i = 0; i < 2; i++)
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ring, width: 2),
              ),
            )
                .animate(delay: (700 * i).ms, onPlay: (c) => c.repeat())
                .scaleXY(begin: 1, end: 2.6, duration: 1400.ms)
                .fadeOut(duration: 1400.ms, curve: Curves.easeIn),
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 14,
                  spreadRadius: 1),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, a) =>
                ScaleTransition(scale: a, child: child),
            child: Icon(icon,
                key: ValueKey(icon), size: 18, color: onAccent(color)),
          ),
        ),
      ],
    );
  }
}

class _Rider extends StatelessWidget {
  final Color accent;
  final double kmLeft;
  const _Rider({required this.accent, required this.kmLeft});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${kmLeft.toStringAsFixed(1)} km',
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: accent, width: 3),
            boxShadow: [
              BoxShadow(
                  color: accent.withValues(alpha: 0.7),
                  blurRadius: 18,
                  spreadRadius: 2),
            ],
          ),
          child: const Icon(Icons.delivery_dining_rounded,
              size: 24, color: Colors.black),
        )
            // little engine-bob as it rides
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: 0, end: -2.5, duration: 260.ms),
        // keep the bubble centred on the route point
        const SizedBox(height: 22),
      ],
    )
        .animate()
        .scaleXY(begin: 0, end: 1, duration: 450.ms, curve: Curves.easeOutBack);
  }
}

/// Streets, a park and a river — the static backdrop of the map.
class _CityPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // river sweeping across the top-left corner
    final river = Path()
      ..moveTo(0, h * 0.06)
      ..cubicTo(w * 0.16, h * 0.10, w * 0.22, h * 0.34, w * 0.50, h * 0.36)
      ..cubicTo(w * 0.40, h * 0.42, w * 0.18, h * 0.40, 0, h * 0.46);
    canvas.drawPath(river,
        Paint()..color = const Color(0xff40C4FF).withValues(alpha: 0.10));

    // park with a scatter of trees
    final park = RRect.fromRectAndRadius(
        Rect.fromLTRB(w * 0.42, h * 0.57, w * 0.62, h * 0.75),
        const Radius.circular(12));
    canvas.drawRRect(
        park, Paint()..color = const Color(0xff69F0AE).withValues(alpha: 0.10));
    final tree = Paint()
      ..color = const Color(0xff69F0AE).withValues(alpha: 0.22);
    final rnd = math.Random(3);
    for (var i = 0; i < 9; i++) {
      canvas.drawCircle(
          Offset(park.left + 8 + rnd.nextDouble() * (park.width - 16),
              park.top + 8 + rnd.nextDouble() * (park.height - 16)),
          2.5 + rnd.nextDouble() * 2.5,
          tree);
    }

    // minor streets
    final minor = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 5;
    for (final x in [0.26, 0.52, 0.76]) {
      canvas.drawLine(Offset(w * x, 0), Offset(w * x, h), minor);
    }
    for (final y in [0.10, 0.38, 0.66, 0.92]) {
      canvas.drawLine(Offset(0, h * y), Offset(w, h * y), minor);
    }

    // main avenues the route follows
    final major = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round;
    for (final x in _avenuesX) {
      canvas.drawLine(Offset(w * x, 0), Offset(w * x, h), major);
    }
    for (final y in _streetsY) {
      canvas.drawLine(Offset(0, h * y), Offset(w, h * y), major);
    }
  }

  @override
  bool shouldRepaint(_CityPainter old) => false;
}

/// The route: a faint dashed full path, and the travelled part glowing in
/// the dish's accent colour.
class _RoutePainter extends CustomPainter {
  final double progress;
  final Color accent;
  _RoutePainter({required this.progress, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final path = _routePath(size);
    final metric = path.computeMetrics().first;

    // dashed "still to go" line
    final dash = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (var d = 0.0; d < metric.length; d += 12) {
      canvas.drawPath(metric.extractPath(d, d + 5), dash);
    }

    if (progress <= 0) return;
    final done = metric.extractPath(0, metric.length * progress);
    canvas.drawPath(
      done,
      Paint()
        ..color = accent.withValues(alpha: 0.55)
        ..strokeWidth = 10
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawPath(
      done,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, size.height),
          Offset(size.width, 0),
          [Color.lerp(accent, Colors.white, 0.35)!, accent],
        )
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RoutePainter old) =>
      old.progress != progress || old.accent != accent;
}
