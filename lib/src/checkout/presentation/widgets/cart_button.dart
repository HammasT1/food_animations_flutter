import 'dart:math' as math;

import 'package:dribbble_challenge/src/checkout/domain/cart.dart';
import 'package:dribbble_challenge/src/core/theme/app_colors.dart';
import 'package:dribbble_challenge/src/core/widget/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Glass cart button with a live item-count badge. Whenever the count goes
/// up it bumps, wiggles, throws off a ring, and the badge digit rolls.
/// Give it a [GlobalKey] to use it as a `flyToTarget` destination.
class CartButton extends ConsumerStatefulWidget {
  final Color accent;
  const CartButton({super.key, this.accent = AppColors.onBoardingButtonColor});

  @override
  ConsumerState<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends ConsumerState<CartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bump = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 650));

  @override
  void dispose() {
    _bump.dispose();
    super.dispose();
  }

  void _open() {
    if (ref.read(cartCountProvider) == 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Your cart is empty — add a dish first'),
        ));
      return;
    }
    Navigator.of(context).pushNamed('checkout');
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(cartCountProvider, (prev, next) {
      if (next > (prev ?? 0)) {
        HapticFeedback.mediumImpact();
        _bump.forward(from: 0);
      }
    });
    final count = ref.watch(cartCountProvider);

    return AnimatedBuilder(
      animation: _bump,
      builder: (context, child) {
        final v = _bump.value;
        // squash-and-stretch: quick swell, settle with a wobble
        final scale = 1 + 0.28 * math.sin(v * math.pi) * (1 - v * 0.6);
        final wiggle = 0.22 * math.sin(v * math.pi * 3) * (1 - v);
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (_bump.isAnimating)
              // impact ring — positioned, so it never resizes the button
              Positioned(
                left: -20 * v,
                top: -20 * v,
                right: -20 * v,
                bottom: -20 * v,
                child: Opacity(
                  opacity: (1 - v).clamp(0.0, 1.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: widget.accent, width: 2.5),
                    ),
                  ),
                ),
              ),
            Transform.rotate(
              angle: wiggle,
              child: Transform.scale(scale: scale, child: child),
            ),
          ],
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GlassIconButton(
            onPressed: _open,
            icon: count > 0
                ? Icons.shopping_bag_rounded
                : Icons.shopping_bag_outlined,
          ),
          Positioned(
            right: -4,
            top: -4,
            child: AnimatedScale(
              scale: count > 0 ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: _Badge(count: count, color: widget.accent),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  final Color color;
  const _Badge({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    final fg = ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black;
    // The badge is scaled away at zero, so never show "0": the first item
    // pops the badge in already reading 1, and the last one shrinks it out.
    final shown = count == 0 ? 1 : count;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      constraints: const BoxConstraints(minWidth: 20),
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff101520), width: 2),
      ),
      alignment: Alignment.center,
      child: ClipRect(
        // odometer roll: the old digit exits upward, the new rises from below
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, a) {
            final incoming = child.key == ValueKey(shown);
            return SlideTransition(
              position: Tween(
                begin: Offset(0, incoming ? 1 : -1),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
              child: child,
            );
          },
          child: Text(
            '$shown',
            key: ValueKey(shown),
            style: TextStyle(
              color: fg,
              fontSize: 10.5,
              height: 1.1,
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}
