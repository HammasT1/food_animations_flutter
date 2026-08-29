import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../domain/recipe.dart';
import 'ingredient_card_widget.dart';

class IngredientsCardList extends StatelessWidget {
  final Recipe recipe;
  final Duration delayTime;
  final Duration slidingDuration;
  final AnimationController ingredientController;
  const IngredientsCardList({
    super.key,
    required this.recipe,
    required this.delayTime,
    required this.slidingDuration,
    required this.ingredientController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        itemCount: recipe.ingredients.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) =>
            IngredientCardWidget(ingredient: recipe.ingredients[index])
                .animate(controller: ingredientController, autoPlay: false)
                .scaleXY(
                    begin: 0,
                    end: 1,
                    duration: 500.ms,
                    delay: (140 * index).ms,
                    curve: Curves.elasticOut)
                .fadeIn(duration: 300.ms, delay: (140 * index).ms)
                .slideX(begin: 0.6, end: 0, curve: Curves.easeOutCubic)
                .shimmer(
                    delay: (140 * index).ms + 300.ms,
                    duration: 700.ms,
                    color: Colors.white.withValues(alpha: 0.3)),
      ),
    );
  }
}
