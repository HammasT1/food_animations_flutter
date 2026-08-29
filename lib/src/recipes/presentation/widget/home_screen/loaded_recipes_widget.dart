import 'package:dribbble_challenge/src/recipes/domain/recipe.dart';
import 'package:dribbble_challenge/src/recipes/presentation/widget/home_screen/recipe_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadedRecipesWidget extends StatelessWidget {
  final List<Recipe> recipes;
  const LoadedRecipesWidget({
    super.key,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        // staggered cascade — each card "falls flat onto the table": it tips in
        // on its X axis in real perspective, unblurs, and settles a beat behind
        // the card above it.
        final stagger = (110 * index).ms;
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              'recipe_details',
              arguments: recipes[index],
            );
          },
          child: RecipeCardWidget(recipe: recipes[index])
              .animate()
              .custom(
                delay: stagger,
                duration: 620.ms,
                curve: Curves.easeOutCubic,
                begin: 1,
                end: 0,
                builder: (context, v, child) => Transform(
                  alignment: Alignment.topCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0011)
                    ..translateByDouble(0.0, v * 34, 0.0, 1.0)
                    ..rotateX(-v * 1.05),
                  child: Opacity(opacity: (1 - v).clamp(0.0, 1.0), child: child),
                ),
              )
              .fadeIn(delay: stagger, duration: 380.ms)
              .blurXY(begin: 10, end: 0, delay: stagger, duration: 460.ms)
              .shimmer(
                  delay: stagger + 260.ms,
                  duration: 900.ms,
                  color: Colors.white.withValues(alpha: 0.18)),
        );
      },
    );
  }
}
