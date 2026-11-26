import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

/// Launches a copy of [child] from the widget at [from] to the widget at
/// [to] along an arc — spinning, shrinking, with a fading motion trail —
/// then calls [onArrive]. Used for the "add to cart" throw.
void flyToTarget({
  required BuildContext context,
  required GlobalKey from,
  required GlobalKey to,
  required Widget child,
  Color glow = Colors.white,
  Duration duration = const Duration(milliseconds: 820),
  VoidCallback? onArrive,
}) {
  final fromBox = from.currentContext?.findRenderObject() as RenderBox?;
  final toBox = to.currentContext?.findRenderObject() as RenderBox?;
  if (fromBox == null || toBox == null) {
    onArrive?.call();
    return;
  }
  final start = fromBox.localToGlobal(fromBox.size.center(Offset.zero));
  final end = toBox.localToGlobal(toBox.size.center(Offset.zero));
  final startSize = math.min(fromBox.size.width, fromBox.size.height) * 0.8;

  final overlay = Overlay.of(context, rootOverlay: true);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _Flight(
      start: start,
      end: end,
      startSize: startSize,
      glow: glow,
      duration: duration,
      onDone: () {
        entry.remove();
        onArrive?.call();
      },
      child: child,
    ),
  );
  overlay.insert(entry);
}

class _Flight extends StatefulWidget {
  final Offset start;
  final Offset end;
  final double startSize;
  final Color glow;
  final Duration duration;
  final VoidCallback onDone;
  final Widget child;

  const _Flight({
    required this.start,
    required this.end,
    required this.startSize,
    required this.glow,
    required this.duration,
    required this.onDone,
    required this.child,
  });

  @override
  State<_Flight> createState() => _FlightState();
}

class _FlightState extends State<_Flight> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration)
        ..addStatusListener((s) {
          if (s == AnimationStatus.completed) widget.onDone();
        })
        ..forward();

  /// Arc control point: pulled up and toward the start, so the dish lifts
  /// off the plate, loops over, and drops into the target.
  late final Offset _control = Offset(
    lerpDouble(widget.start.dx, widget.end.dx, 0.25)!,
    math.max(24, math.min(widget.start.dy, widget.end.dy) - 150),
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Offset _point(double t) {
    final u = 1 - t;
    return widget.start * (u * u) +
        _control * (2 * u * t) +
        widget.end * (t * t);
  }

  Widget _frame(double raw, {double opacity = 1}) {
    final t = Curves.easeInOutCubic.transform(raw.clamp(0.0, 1.0));
    final size = lerpDouble(
        widget.startSize, 26, Curves.easeInQuad.transform(raw.clamp(0, 1)))!;
    final p = _point(t);
    // a quick lift-off pop before it shrinks away
    final pop = 1 + 0.18 * math.sin(math.min(raw / 0.25, 1) * math.pi);
    final fadeOut = raw > 0.85 ? 1 - (raw - 0.85) / 0.15 : 1.0;
    return Positioned(
      left: p.dx - size / 2,
      top: p.dy - size / 2,
      width: size,
      height: size,
      child: Opacity(
        opacity: (opacity * fadeOut).clamp(0.0, 1.0),
        child: Transform.rotate(
          angle: t * math.pi * 1.5,
          child: Transform.scale(
            scale: pop,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.glow.withValues(alpha: 0.55 * opacity),
                    blurRadius: size * 0.35,
                    spreadRadius: -size * 0.08,
                  ),
                ],
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final v = _c.value;
          return Stack(
            children: [
              // motion trail: fading ghosts a step behind
              for (var i = 3; i >= 1; i--)
                if (v - i * 0.05 > 0)
                  _frame(v - i * 0.05, opacity: 0.12 * (4 - i)),
              _frame(v),
            ],
          );
        },
      ),
    );
  }
}
