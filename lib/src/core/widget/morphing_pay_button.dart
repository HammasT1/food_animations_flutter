import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// The showpiece button: tap it and the pill collapses into a coin, spins a
/// loader while "processing", then the coin balloons out to fill the screen and
/// hands off to the next screen — a seamless colour-matched transition.
class MorphingPayButton extends StatefulWidget {
  final String label;
  final Color color;
  final Color textColor;
  final Duration processDuration;
  final Future<void> Function()? onProcess;
  final VoidCallback onComplete;

  const MorphingPayButton({
    super.key,
    required this.label,
    required this.onComplete,
    this.color = const Color(0xff0FA958),
    this.textColor = Colors.white,
    this.processDuration = const Duration(milliseconds: 1700),
    this.onProcess,
  });

  @override
  State<MorphingPayButton> createState() => _MorphingPayButtonState();
}

enum _Phase { idle, collapsing, processing, expanding }

class _MorphingPayButtonState extends State<MorphingPayButton>
    with TickerProviderStateMixin {
  static const double _h = 64;

  late final AnimationController _morph =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 340));
  late final AnimationController _expand =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 520));
  late final AnimationController _spin =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

  _Phase _phase = _Phase.idle;
  bool _pressed = false;
  OverlayEntry? _entry;

  @override
  void dispose() {
    _removeOverlay();
    _morph.dispose();
    _expand.dispose();
    _spin.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    _entry?.remove();
    _entry = null;
  }

  Future<void> _run() async {
    if (_phase != _Phase.idle) return;
    setState(() => _phase = _Phase.collapsing);
    await _morph.forward();

    if (!mounted) return;
    setState(() => _phase = _Phase.processing);
    _spin.repeat();
    if (widget.onProcess != null) {
      await widget.onProcess!();
    } else {
      await Future<void>.delayed(widget.processDuration);
    }
    if (!mounted) return;
    _spin.stop();

    setState(() => _phase = _Phase.expanding);
    _insertOverlay();
    await _expand.forward();
    widget.onComplete();
    await Future<void>.delayed(const Duration(milliseconds: 140));
    _removeOverlay();
  }

  void _insertOverlay() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final center = box.localToGlobal(box.size.center(Offset.zero));
    final media = MediaQuery.of(context).size;
    final diag = math.sqrt(media.width * media.width + media.height * media.height);
    final maxScale = (diag / _h) * 1.15;

    _entry = OverlayEntry(
      builder: (_) => AnimatedBuilder(
        animation: _expand,
        builder: (_, __) {
          final v = Curves.easeInCubic.transform(_expand.value);
          return Positioned(
            left: center.dx - _h / 2,
            top: center.dy - _h / 2,
            child: Transform.scale(
              scale: 1 + (maxScale - 1) * v,
              child: Container(
                width: _h,
                height: _h,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        },
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _phase == _Phase.idle ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: () => setState(() => _pressed = false),
      onTap: _phase == _Phase.idle
          ? () {
              setState(() => _pressed = false);
              _run();
            }
          : null,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final fullWidth = constraints.maxWidth;
            return AnimatedBuilder(
              animation: Listenable.merge([_morph, _spin]),
              builder: (context, _) {
                final m = Curves.easeInOutCubic.transform(_morph.value);
                final width = fullWidth - (fullWidth - _h) * m;
                final showSpinner = _phase == _Phase.processing ||
                    _phase == _Phase.expanding;
                return Center(
                  child: Container(
                    width: width,
                    height: _h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(_h / 2),
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.45),
                          blurRadius: 26,
                          spreadRadius: 1,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: showSpinner
                        ? CustomPaint(
                            size: const Size(26, 26),
                            painter: _ArcSpinnerPainter(
                                _spin.value, widget.textColor),
                          )
                        : Opacity(
                            opacity: (1 - m * 2).clamp(0.0, 1.0),
                            child: Text(
                              widget.label,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              softWrap: false,
                              style: TextStyle(
                                color: widget.textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                  ),
                );
              },
            );
          },
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
            delay: 1200.ms,
            duration: 1800.ms,
            color: Colors.white.withValues(alpha: 0.25));
  }
}

class _ArcSpinnerPainter extends CustomPainter {
  final double t;
  final Color color;
  _ArcSpinnerPainter(this.t, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..color = color;
    final start = t * 2 * math.pi;
    // sweep breathes between a short and long arc for a lively spinner
    final sweep = math.pi * (0.55 + 0.35 * math.sin(t * 2 * math.pi));
    canvas.drawArc(rect.deflate(2), start, sweep, false, paint);
  }

  @override
  bool shouldRepaint(_ArcSpinnerPainter old) => old.t != t;
}
