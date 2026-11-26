// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dribbble_challenge/src/checkout/domain/cart.dart';
import 'package:dribbble_challenge/src/checkout/domain/order_draft.dart';
import 'package:dribbble_challenge/src/checkout/presentation/widgets/cart_button.dart';
import 'package:dribbble_challenge/src/core/theme/app_theme.dart';
import 'package:dribbble_challenge/src/core/theme/dish_accent.dart';
import 'package:dribbble_challenge/src/core/widget/annotated_scaffold.dart';
import 'package:dribbble_challenge/src/core/widget/fly_to_target.dart';
import 'package:dribbble_challenge/src/core/widget/animated_price.dart';
import 'package:dribbble_challenge/src/core/widget/glass_container.dart';
import 'package:dribbble_challenge/src/core/widget/shine_sweep.dart';
import 'package:dribbble_challenge/src/recipes/presentation/widget/recipe_details/recipe_details_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dribbble_challenge/src/recipes/domain/recipe.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeDetailsScreen extends ConsumerStatefulWidget {
  final Recipe recipe;
  const RecipeDetailsScreen({
    super.key,
    required this.recipe,
  });

  @override
  ConsumerState<RecipeDetailsScreen> createState() =>
      _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends ConsumerState<RecipeDetailsScreen> {
  // launch point and landing spot for the add-to-cart throw
  final _dishKey = GlobalKey();
  final _cartKey = GlobalKey();

  Recipe get recipe => widget.recipe;

  void _addToCart(Color accent) {
    HapticFeedback.lightImpact();
    flyToTarget(
      context: context,
      from: _dishKey,
      to: _cartKey,
      glow: accent,
      child: Image.asset(recipe.imageUrl, fit: BoxFit.contain),
      // the item lands in the cart when the dish does — the badge bumps then
      onArrive: () {
        if (mounted) ref.read(cartProvider.notifier).add(recipe);
      },
    );
  }

  void _orderNow() {
    final cart = ref.read(cartProvider.notifier);
    if (!cart.contains(recipe)) cart.add(recipe);
    Navigator.of(context).pushNamed('checkout');
  }

  @override
  Widget build(BuildContext context) {
    final previewPrice = unitPriceOf(recipe);
    final accent = watchDishAccent(ref, recipe.imageUrl);
    return AnnotatedScaffold(
      accent: accent,
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
                    trailing: CartButton(key: _cartKey, accent: accent),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  AnimatedDishWidget(
                    key: _dishKey,
                    constraints: constraints,
                    imageUrl: recipe.imageUrl,
                    dishPlayTime: dishPlayTime,
                    heroTag: 'dish-${recipe.id}',
                    glowColor: accent,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.06),
                  AnimatedInfoWidget(
                      nutrition: recipe.nutrition,
                      infoDelayTime: infoDelayTime,
                      infoPlayTime: infoPlayTime,
                      constraints: constraints,
                      accent: softAccent(accent)),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _OrderBar(
                unitPrice: previewPrice,
                accent: accent,
                onTap: _orderNow,
                onAdd: () => _addToCart(accent),
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
  final VoidCallback onAdd;
  final Color accent;
  const _OrderBar(
      {required this.unitPrice,
      required this.onTap,
      required this.onAdd,
      required this.accent});

  @override
  Widget build(BuildContext context) {
    // a frosted "dock" floating over the panel, with the CTA inside it
    return GlassContainer(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(7),
      borderRadius: BorderRadius.circular(38),
      opacity: 0.45,
      child: Row(
        children: [
          _AddToCartButton(onTap: onAdd, accent: accent),
          const SizedBox(width: 8),
          Expanded(child: _orderButton()),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 1400.ms, duration: 500.ms)
        .slideY(begin: 1.2, end: 0, curve: Curves.easeOutBack);
  }

  Widget _orderButton() {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(31),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.45),
              blurRadius: 26,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(31),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(accent, Colors.white, 0.18)!,
                accent,
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order Now',
                  style: TextStyle(
                      color: onAccent(accent),
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2)),
              AnimatedPrice(
                value: unitPrice,
                style: TextStyle(
                    color: onAccent(accent),
                    fontFamily: AppFonts.display,
                    fontSize: 28,
                    height: 1.1),
              ),
            ],
          ),
        ).shineSweep(startDelay: const Duration(milliseconds: 2200)),
      ),
    )
        // gentle breathing to pull the tap
        .animate(
          onPlay: (c) => c.repeat(reverse: true),
          delay: 2100.ms,
        )
        .scaleXY(
            begin: 1, end: 1.03, duration: 1300.ms, curve: Curves.easeInOut);
  }
}

/// Round glass "+ bag" button — throws the dish into the cart.
class _AddToCartButton extends StatefulWidget {
  final VoidCallback onTap;
  final Color accent;
  const _AddToCartButton({required this.onTap, required this.accent});

  @override
  State<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<_AddToCartButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapUp: (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.88 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.accent.withValues(alpha: 0.16),
            border: Border.all(
                color: widget.accent.withValues(alpha: 0.7), width: 1.5),
          ),
          child: Icon(Icons.add_shopping_cart_rounded,
              color: softAccent(widget.accent), size: 24),
        ),
      ),
    );
  }
}
