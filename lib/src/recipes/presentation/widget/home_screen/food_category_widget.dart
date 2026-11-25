import 'package:dribbble_challenge/src/core/widget/animated_gradient_border.dart';
import 'package:dribbble_challenge/src/core/widget/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FoodCategoryWidget extends StatelessWidget {
  final String icon;
  final String name;
  final bool selected;
  final VoidCallback? onTap;

  const FoodCategoryWidget({
    super.key,
    required this.icon,
    required this.name,
    this.selected = false,
    this.onTap,
  });

  static const _radius = BorderRadius.all(Radius.circular(25));

  @override
  Widget build(BuildContext context) {
    return Padding(
      // vertical room so the selected ring's glow isn't clipped by the list
      padding: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
      child: GestureDetector(
        onTap: onTap == null
            ? null
            : () {
                HapticFeedback.selectionClick();
                onTap!();
              },
        child: AnimatedGradientBorder(
          active: selected,
          borderRadius: _radius,
          colors: const [
            Color(0xffFFD54F),
            Color(0xffFF7043),
            Color(0xffFFF3E0),
            Color(0xffFFB300),
          ],
          child: GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            borderRadius: _radius,
            opacity: selected ? 0.55 : 0.35,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  icon,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  width: 5,
                ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 15,
                        fontWeight:
                            selected ? FontWeight.w800 : FontWeight.w600,
                        letterSpacing: 0.2,
                        color: selected ? Colors.white : Colors.white70,
                      ),
                  child: Text(name),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
