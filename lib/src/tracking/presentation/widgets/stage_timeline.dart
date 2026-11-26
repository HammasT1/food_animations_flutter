import 'package:dribbble_challenge/src/core/theme/dish_accent.dart';
import 'package:dribbble_challenge/src/tracking/domain/delivery_stage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Vertical delivery timeline: done steps are filled with a check, the
/// current step pulses, and the connector below it fills as the step runs.
class StageTimeline extends StatelessWidget {
  /// Position on the demo timeline, 0..1.
  final double t;
  final Color accent;

  /// Clock time each stage starts at (real or estimated).
  final Map<DeliveryStage, DateTime> times;

  const StageTimeline({
    super.key,
    required this.t,
    required this.accent,
    required this.times,
  });

  @override
  Widget build(BuildContext context) {
    final current = DeliveryStage.at(t);
    const stages = DeliveryStage.values;
    return Column(
      children: [
        for (var i = 0; i < stages.length; i++)
          _StageRow(
            stage: stages[i],
            state: stages[i].index < current.index
                ? _State.done
                : stages[i] == current
                    ? (current == DeliveryStage.delivered
                        ? _State.done
                        : _State.active)
                    : _State.pending,
            connectorFill: i == stages.length - 1
                ? null
                : stages[i].index < current.index
                    ? 1
                    : stages[i] == current
                        ? stages[i].progressAt(t)
                        : 0,
            time: times[stages[i]]!,
            accent: accent,
          )
              .animate()
              .fadeIn(delay: (500 + i * 120).ms, duration: 400.ms)
              .slideX(begin: 0.12, end: 0, curve: Curves.easeOutCubic),
      ],
    );
  }
}

enum _State { done, active, pending }

class _StageRow extends StatelessWidget {
  final DeliveryStage stage;
  final _State state;
  final double? connectorFill;
  final DateTime time;
  final Color accent;

  const _StageRow({
    required this.stage,
    required this.state,
    required this.connectorFill,
    required this.time,
    required this.accent,
  });

  static const _node = 36.0;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final reached = state != _State.pending;
    // fixed row heights: cheap to lay out every frame while the timeline runs
    return SizedBox(
      height: connectorFill == null ? 54 : 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: _node,
            child: Column(
              children: [
                _Node(stage: stage, state: state, accent: accent),
                if (connectorFill != null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _Connector(fill: connectorFill!, accent: accent),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: text.titleMedium!.copyWith(
                        color: reached ? Colors.white : Colors.white38),
                    child: Text(stage.title),
                  ),
                  const SizedBox(height: 2),
                  Text(stage.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(
                          color: reached ? Colors.white60 : Colors.white24)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _clock(time),
              style: text.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: reached ? softAccent(accent) : Colors.white24,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _clock(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m ${t.hour < 12 ? 'AM' : 'PM'}';
  }
}

class _Node extends StatelessWidget {
  final DeliveryStage stage;
  final _State state;
  final Color accent;
  const _Node({required this.stage, required this.state, required this.accent});

  @override
  Widget build(BuildContext context) {
    const size = _StageRow._node;
    final core = AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: switch (state) {
          _State.done => accent,
          _State.active => accent.withValues(alpha: 0.18),
          _State.pending => Colors.white.withValues(alpha: 0.05),
        },
        border: Border.all(
          color: state == _State.pending ? Colors.white24 : accent,
          width: 2,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, a) => ScaleTransition(
            scale: CurvedAnimation(parent: a, curve: Curves.easeOutBack),
            child: child),
        child: Icon(
          state == _State.done ? Icons.check_rounded : stage.icon,
          key: ValueKey(state == _State.done),
          size: 18,
          color: switch (state) {
            _State.done => onAccent(accent),
            _State.active => accent,
            _State.pending => Colors.white38,
          },
        ),
      ),
    );

    if (state != _State.active) return core;
    // the live step breathes a halo
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accent.withValues(alpha: 0.35),
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .scaleXY(begin: 1, end: 1.7, duration: 1200.ms)
            .fadeOut(duration: 1200.ms, curve: Curves.easeIn),
        core,
      ],
    );
  }
}

class _Connector extends StatelessWidget {
  final double fill;
  final Color accent;
  const _Connector({required this.fill, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 3,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(2),
        ),
        alignment: Alignment.topCenter,
        child: FractionallySizedBox(
          heightFactor: fill,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [accent, Color.lerp(accent, Colors.white, 0.4)!],
              ),
              boxShadow: [
                BoxShadow(color: accent.withValues(alpha: 0.6), blurRadius: 6)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
