// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../domain/recipe.dart';

class RecipeCardWidget extends StatelessWidget {
  final Recipe recipe;
  const RecipeCardWidget({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final playDuration = 600.ms;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _AnimatedImageWidget(
              imageUrl: recipe.imageUrl,
              heroTag: 'dish-${recipe.id}',
              playDuration: playDuration,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AnimatedNutritionText(
                  playDuration: playDuration,
                  nutrition: recipe.nutrition,
                ),
                _AnimatedNameWidget(
                    playDuration: playDuration, name: recipe.name),
                _AnimatedDescriptionWidget(
                    playDuration: playDuration, description: recipe.description)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _AnimatedNutritionText extends StatelessWidget {
  final Duration playDuration;
  final Map<String, dynamic> nutrition;
  const _AnimatedNutritionText({
    required this.playDuration,
    required this.nutrition,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        "${nutrition["calories"]}cal \t\t\t\t${nutrition["protein"]}protein",
        style: Theme.of(context).textTheme.labelMedium,
      )
          .animate()
          .fadeIn(delay: 250.ms, duration: 350.ms)
          .slideX(begin: 0.35, end: 0, curve: Curves.easeOutCubic)
          .blurX(begin: 6, end: 0),
    );
  }
}

class _AnimatedImageWidget extends StatelessWidget {
  final Duration playDuration;
  final String imageUrl;
  final String heroTag;
  const _AnimatedImageWidget({
    required this.playDuration,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      // keep the image flat & clean during the hero flight
      flightShuttleBuilder: (_, __, ___, ____, toHeroContext) =>
          toHeroContext.widget,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 150, maxWidth: 150),
        child: Image.asset(
          imageUrl,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      )
          // spin-in on a plate, catch a light sweep
          .animate()
          .scale(
              begin: const Offset(0.3, 0.3),
              end: const Offset(1, 1),
              duration: playDuration,
              curve: Curves.easeOutBack)
          .rotate(begin: -0.35, end: 0, duration: playDuration, curve: Curves.easeOutCubic)
          .fadeIn(duration: 350.ms)
          .shimmer(
              delay: playDuration - 100.ms,
              duration: 800.ms,
              color: Colors.white.withValues(alpha: 0.4))
          // then hover forever
          .animate(
            delay: playDuration + 100.ms,
            onPlay: (c) => c.repeat(reverse: true),
          )
          .moveY(begin: 0, end: -8, duration: 2400.ms, curve: Curves.easeInOut)
          .rotate(
              begin: -0.008,
              end: 0.008,
              duration: 2400.ms,
              curve: Curves.easeInOut),
    );
  }
}

class _AnimatedNameWidget extends StatelessWidget {
  final Duration playDuration;
  final String name;
  const _AnimatedNameWidget({
    required this.playDuration,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      alignment: Alignment.centerLeft,
      child: Text(name,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              softWrap: true,
              style: Theme.of(context).textTheme.titleLarge)
          .animate()
          .fadeIn(duration: 350.ms, delay: 200.ms, curve: Curves.easeOut)
          .slideX(begin: 0.4, end: 0, curve: Curves.easeOutCubic)
          .blurX(begin: 8, end: 0),
    );
  }
}

class _AnimatedDescriptionWidget extends StatelessWidget {
  final Duration playDuration;
  final String description;
  const _AnimatedDescriptionWidget({
    required this.playDuration,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      child: Text(description,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              softWrap: true,
              style: Theme.of(context).textTheme.labelLarge)
          .animate()
          .fadeIn(delay: 350.ms, duration: 400.ms, curve: Curves.easeOut)
          .slideY(begin: 0.4, end: 0, curve: Curves.easeOutCubic),
    );
  }
}
