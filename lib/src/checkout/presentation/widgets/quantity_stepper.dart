import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dribbble_challenge/src/core/theme/app_colors.dart';

/// − [ n ] +  with a springy digit swap and a tactile bump.
class QuantityStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 20,
  });

  void _bump(int next) {
    if (next < min || next > max) return;
    HapticFeedback.lightImpact();
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoundButton(
            icon: Icons.remove_rounded,
            enabled: value > min,
            onTap: () => _bump(value - 1),
          ),
          SizedBox(
            width: 44,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                transitionBuilder: (child, anim) {
                  final curved =
                      CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
                  return ScaleTransition(
                    scale: curved,
                    child: FadeTransition(opacity: anim, child: child),
                  );
                },
                child: Text(
                  '$value',
                  key: ValueKey(value),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          _RoundButton(
            icon: Icons.add_rounded,
            enabled: value < max,
            accent: true,
            onTap: () => _bump(value + 1),
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatefulWidget {
  final IconData icon;
  final bool enabled;
  final bool accent;
  final VoidCallback onTap;
  const _RoundButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    this.accent = false,
  });

  @override
  State<_RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<_RoundButton> {
  double _s = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _s = 0.82) : null,
      onTapUp: widget.enabled ? (_) => setState(() => _s = 1) : null,
      onTapCancel: () => setState(() => _s = 1),
      onTap: widget.enabled ? widget.onTap : null,
      child: AnimatedScale(
        scale: _s,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.accent && widget.enabled
                ? AppColors.onBoardingButtonColor
                : Colors.white.withValues(alpha: 0.10),
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: widget.accent && widget.enabled
                ? Colors.black
                : (widget.enabled ? Colors.white : Colors.white30),
          ),
        ),
      ),
    );
  }
}
