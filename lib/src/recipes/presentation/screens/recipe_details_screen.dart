// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dribbble_challenge/src/checkout/domain/order_draft.dart';
import 'package:dribbble_challenge/src/core/theme/app_colors.dart';
import 'package:dribbble_challenge/src/core/widget/annotated_scaffold.dart';
import 'package:dribbble_challenge/src/core/widget/animated_price.dart';
import 'package:dribbble_challenge/src/recipes/presentation/widget/recipe_details/recipe_details_widgets.dart';
import 'package:flutter/material.dart';
import 'package:dribbble_challenge/src/recipes/domain/recipe.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailsScreen({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final previewPrice = OrderDraft(recipe: recipe).unitPrice;
    return AnnotatedScaffold(
      child: LayoutBuilder(builder: (context, constraints) {
        final appBarPlayTime = 800.ms;
        final appBarDelayTime = 400.ms;
        final infoDelayTime = appBarPlayTime + appBarDelayTime - 200.ms;
        final infoPlayTime = 500.ms;
        final dishPlayTime = 600.ms;
        return Stack(
          children: [
            TimeLineSlidingPanel(
              recipe: recipe,
              constraints: constraints,
              body: Column(
                children: [
                  AnimatedAppBarWidget(
                    name: recipe.name,
                    appBarPlayTime: appBarPlayTime,
                    appBarDelayTime: appBarDelayTime,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  AnimatedDishWidget(
                    constraints: constraints,
                    imageUrl: recipe.imageUrl,
                    dishPlayTime: dishPlayTime,
                    heroTag: 'dish-${recipe.id}',
                  ),
                  SizedBox(height: constraints.maxHeight * 0.06),
                  AnimatedInfoWidget(
                      nutrition: recipe.nutrition,
                      infoDelayTime: infoDelayTime,
                      infoPlayTime: infoPlayTime,
                      constraints: constraints),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _OrderBar(
                unitPrice: previewPrice,
                onTap: () => Navigator.of(context)
                    .pushNamed('checkout', arguments: recipe),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _OrderBar extends StatelessWidget {
  final double unitPrice;
  final VoidCallback onTap;
  const _OrderBar({required this.unitPrice, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.35, 0.6],
          colors: [
            AppColors.scaffoldBackgroundColor.withValues(alpha: 0),
            AppColors.cardColor,
            AppColors.cardColor,
          ],
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            color: AppColors.onBoardingButtonColor,
            borderRadius: BorderRadius.circular(31),
            boxShadow: [
              BoxShadow(
                color: AppColors.onBoardingButtonColor.withValues(alpha: 0.45),
                blurRadius: 26,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Order Now',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              AnimatedPrice(
                value: unitPrice,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 1400.ms, duration: 500.ms)
        .slideY(begin: 1.2, end: 0, curve: Curves.easeOutBack)
        .animate(
          onPlay: (c) => c.repeat(reverse: true),
          delay: 2100.ms,
        )
        .scaleXY(begin: 1, end: 1.03, duration: 1300.ms, curve: Curves.easeInOut);
  }
}
