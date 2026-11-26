import 'dart:math' as math;

import 'package:dribbble_challenge/src/core/theme/dish_accent.dart';
import 'package:dribbble_challenge/src/core/widget/annotated_scaffold.dart';
import 'package:dribbble_challenge/src/core/widget/confetti_overlay.dart';
import 'package:dribbble_challenge/src/core/widget/glass_container.dart';
import 'package:dribbble_challenge/src/core/widget/shine_sweep.dart';
import 'package:dribbble_challenge/src/tracking/domain/delivery_stage.dart';
import 'package:dribbble_challenge/src/tracking/presentation/widgets/delivery_map.dart';
import 'package:dribbble_challenge/src/tracking/presentation/widgets/stage_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Live order tracking. The whole delivery is simulated on a compressed
/// timeline ([demoLength]) so it can be watched end to end, while the clock
/// times and countdown are scaled to the order's real ETA.
class OrderTrackingScreen extends ConsumerStatefulWidget {
  final TrackingArgs args;
  final Duration demoLength;

  const OrderTrackingScreen({
    super.key,
    required this.args,
    this.demoLength = const Duration(seconds: 26),
  });

  @override
  ConsumerState<OrderTrackingScreen> createState() =>
      _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _timeline =
      AnimationController(vsync: this, duration: widget.demoLength)
        ..addListener(_onTick)
        ..forward();
  final DateTime _placedAt = DateTime.now();
  DeliveryStage _stage = DeliveryStage.confirmed;

  int get _eta => widget.args.order.etaMinutes;

  late final Map<DeliveryStage, DateTime> _times = {
    for (final s in DeliveryStage.values)
      s: _placedAt.add(Duration(minutes: (_eta * s.start).round())),
  };

  void _onTick() {
    final s = DeliveryStage.at(_timeline.value);
    if (s == _stage) return;
    setState(() => _stage = s);
    if (s == DeliveryStage.delivered) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.selectionClick();
    }
  }

  @override
  void dispose() {
    _timeline.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.args.order;
    final accent = watchDishAccent(ref, order.recipe.imageUrl);
    final delivered = _stage == DeliveryStage.delivered;

    return AnnotatedScaffold(
      accent: accent,
      child: Stack(
        children: [
          Column(
            children: [
              _Header(
                orderId: widget.args.orderId,
                image: order.recipe.imageUrl,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    GlassContainer(
                      height: 260,
                      borderRadius: BorderRadius.circular(28),
                      opacity: 0.45,
                      child: AnimatedBuilder(
                        animation: _timeline,
                        builder: (context, _) => DeliveryMap(
                          progress: Curves.easeInOutSine.transform(DeliveryStage
                              .onTheWay
                              .progressAt(_timeline.value)),
                          stage: _stage,
                          accent: accent,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 100.ms, duration: 500.ms)
                        .scaleXY(
                            begin: 0.92, end: 1, curve: Curves.easeOutCubic)
                        .blurXY(begin: 10, end: 0),
                    const SizedBox(height: 14),
                    AnimatedBuilder(
                      animation: _timeline,
                      builder: (context, _) => _EtaCard(
                        t: _timeline.value,
                        stage: _stage,
                        minutesLeft:
                            math.max(1, (_eta * (1 - _timeline.value)).ceil()),
                        arrival: _times[DeliveryStage.delivered]!,
                        accent: accent,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 280.ms, duration: 450.ms)
                        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                    const SizedBox(height: 14),
                    GlassContainer(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                      borderRadius: BorderRadius.circular(24),
                      child: AnimatedBuilder(
                        animation: _timeline,
                        builder: (context, _) => StageTimeline(
                          t: _timeline.value,
                          accent: accent,
                          times: _times,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 420.ms, duration: 450.ms)
                        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                    const SizedBox(height: 14),
                    _RiderCard(accent: accent, active: _stage.index >= 2)
                        .animate()
                        .fadeIn(delay: 620.ms, duration: 450.ms)
                        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutCubic,
                child: delivered
                    ? _HomeBar(accent: accent)
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
          if (delivered)
            Positioned.fill(
              child: IgnorePointer(
                child: ConfettiOverlay(
                  origin: const Alignment(0, -0.35),
                  colors: [
                    accent,
                    Color.lerp(accent, Colors.white, 0.4)!,
                    const Color(0xff0FA958),
                    const Color(0xffFFC107),
                    Colors.white,
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String orderId;
  final String image;
  const _Header({required this.orderId, required this.image});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 20, 8),
      child: Row(
        children: [
          GlassIconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icons.arrow_back_ios_new,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Track Order', style: text.headlineMedium),
                Text('Order $orderId', style: text.bodySmall),
              ],
            ),
          ),
          GlassContainer(
            width: 52,
            height: 52,
            borderRadius: BorderRadius.circular(26),
            padding: const EdgeInsets.all(4),
            child: Image.asset(image, fit: BoxFit.contain),
          ),
        ]
            .animate(interval: 90.ms)
            .fadeIn(duration: 400.ms)
            .slideY(begin: -0.6, end: 0, curve: Curves.easeOutBack),
      ),
    );
  }
}

class _EtaCard extends StatelessWidget {
  final double t;
  final DeliveryStage stage;
  final int minutesLeft;
  final DateTime arrival;
  final Color accent;

  const _EtaCard({
    required this.t,
    required this.stage,
    required this.minutesLeft,
    required this.arrival,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final delivered = stage == DeliveryStage.delivered;
    final h = arrival.hour % 12 == 0 ? 12 : arrival.hour % 12;
    final clock =
        '$h:${arrival.minute.toString().padLeft(2, '0')} ${arrival.hour < 12 ? 'AM' : 'PM'}';

    return GlassContainer(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
      borderRadius: BorderRadius.circular(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(delivered ? 'Arrived at' : 'Arriving in',
                    style: text.bodySmall),
                const SizedBox(height: 2),
                // minutes tick crisply (tabular digits, no jitter); the switch
                // to the arrival time rolls up once on delivery
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, a) => ClipRect(
                    child: SlideTransition(
                      position:
                          Tween(begin: const Offset(0, 0.6), end: Offset.zero)
                              .animate(CurvedAnimation(
                                  parent: a, curve: Curves.easeOutCubic)),
                      child: FadeTransition(opacity: a, child: child),
                    ),
                  ),
                  child: Text.rich(
                    key: ValueKey(delivered),
                    TextSpan(children: [
                      TextSpan(text: delivered ? clock : '$minutesLeft'),
                      if (!delivered)
                        TextSpan(
                          text: ' min',
                          style:
                              text.titleMedium?.copyWith(color: Colors.white60),
                        ),
                    ]),
                    style: text.headlineMedium?.copyWith(
                      fontSize: 40,
                      height: 1.1,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  delivered
                      ? 'Delivered — enjoy your meal'
                      : 'Estimated arrival $clock',
                  style: text.bodySmall?.copyWith(color: softAccent(accent)),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 74,
            height: 74,
            child: CustomPaint(
              painter: _RingPainter(progress: t, accent: accent),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, a) => ScaleTransition(
                      scale:
                          CurvedAnimation(parent: a, curve: Curves.easeOutBack),
                      child: child),
                  child: Icon(stage.icon,
                      key: ValueKey(stage), color: Colors.white, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color accent;
  _RingPainter({required this.progress, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 6.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    canvas.drawArc(
        rect,
        0,
        math.pi * 2,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..color = Colors.white.withValues(alpha: 0.08));
    if (progress <= 0) return;
    final sweep = math.pi * 2 * progress;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: sweep,
        colors: [Color.lerp(accent, Colors.white, 0.4)!, accent],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(rect);
    canvas.drawArc(rect, -math.pi / 2, sweep, false, paint);
    // a bright head at the leading edge
    final head = Offset(
      rect.center.dx + rect.width / 2 * math.cos(-math.pi / 2 + sweep),
      rect.center.dy + rect.height / 2 * math.sin(-math.pi / 2 + sweep),
    );
    canvas.drawCircle(
        head,
        5,
        Paint()
          ..color = accent
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    canvas.drawCircle(head, 3, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.accent != accent;
}

class _RiderCard extends StatelessWidget {
  final Color accent;

  /// Whether the rider has been dispatched yet.
  final bool active;
  const _RiderCard({required this.accent, required this.active});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: active ? 1 : 0.55,
      child: GlassContainer(
        padding: const EdgeInsets.all(14),
        borderRadius: BorderRadius.circular(24),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color.lerp(accent, Colors.white, 0.3)!, accent],
                ),
              ),
              child: Text('JM',
                  style: text.titleMedium?.copyWith(color: onAccent(accent))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jordan M.', style: text.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    active
                        ? 'Your delivery partner'
                        : 'Will pick up when food is ready',
                    style: text.bodySmall,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded,
                      size: 16, color: Color(0xffFFC107)),
                  const SizedBox(width: 3),
                  Text('4.9',
                      style: text.titleSmall?.copyWith(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeBar extends StatelessWidget {
  final Color accent;
  const _HomeBar({required this.accent});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      opacity: 0.6,
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamedAndRemoveUntil('home', (r) => r.isFirst),
        child: Container(
          height: 58,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(29),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.lerp(accent, Colors.white, 0.18)!, accent],
            ),
          ),
          child: Text(
            'Back to Home',
            style: TextStyle(
                color: onAccent(accent),
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2),
          ),
        ).shineSweep(startDelay: const Duration(milliseconds: 900)),
      ),
    ).animate().slideY(begin: 1, end: 0, curve: Curves.easeOutCubic);
  }
}
