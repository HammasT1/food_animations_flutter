import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'food_category_widget.dart';

class AnimatedCategoryList extends StatelessWidget {
  final Duration categoryListPlayDuration;
  final Duration categoryListDelayDuration;
  const AnimatedCategoryList({
    super.key,
    required this.categoryListPlayDuration,
    required this.categoryListDelayDuration,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 50, minHeight: 40),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 15),
        children: List.generate(_categories.length, (index) => _categories[index])
            .animate(interval: 90.ms, delay: categoryListDelayDuration)
            .slideX(
                duration: categoryListPlayDuration,
                begin: 1.6,
                end: 0,
                curve: Curves.easeOutBack)
            .fadeIn(duration: 350.ms)
            .scaleXY(begin: 0.7, end: 1, curve: Curves.easeOutBack)
            .blurX(begin: 6, end: 0, duration: 300.ms)
            .shimmer(
                delay: 200.ms,
                duration: 700.ms,
                color: Colors.white.withValues(alpha: 0.25)),
      ),
    );
  }
}

final _categories = [
  const FoodCategoryWidget(icon: "🔥", name: "Popular"),
  const FoodCategoryWidget(icon: "🥦", name: "Healthy"),
  const FoodCategoryWidget(icon: "🍲", name: "Soup"),
  const FoodCategoryWidget(icon: "🍿", name: "Snacks"),
];
