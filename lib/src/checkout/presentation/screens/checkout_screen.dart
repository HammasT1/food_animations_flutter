import 'package:dribbble_challenge/src/core/theme/app_colors.dart';
import 'package:dribbble_challenge/src/core/theme/dish_accent.dart';
import 'package:dribbble_challenge/src/core/widget/animated_price.dart';
import 'package:dribbble_challenge/src/core/widget/annotated_scaffold.dart';
import 'package:dribbble_challenge/src/core/widget/dashed_divider.dart';
import 'package:dribbble_challenge/src/core/widget/glass_container.dart';
import 'package:dribbble_challenge/src/core/widget/shine_sweep.dart';
import 'package:dribbble_challenge/src/checkout/domain/cart.dart';
import 'package:dribbble_challenge/src/checkout/domain/order_draft.dart';
import 'package:dribbble_challenge/src/checkout/presentation/widgets/quantity_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = ref.watch(cartProvider);
    if (lines.isEmpty) return const _EmptyCart();

    final text = Theme.of(context).textTheme;
    final order = OrderDraft(lines: lines);
    final accent = watchDishAccent(ref, order.recipe.imageUrl);
    final cart = ref.read(cartProvider.notifier);
    return AnnotatedScaffold(
      accent: accent,
      child: Column(
        children: [
          _Header(title: 'Checkout', count: order.itemCount),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              children: [
                for (var i = 0; i < lines.length; i++)
                  Padding(
                    key: ValueKey(lines[i].recipe.id),
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _LineCard(
                      line: lines[i],
                      onQty: (q) => cart.setQuantity(lines[i].recipe, q),
                    )
                        .animate()
                        .fadeIn(delay: (120 + i * 90).ms, duration: 450.ms)
                        .slideY(begin: 0.25, end: 0, curve: Curves.easeOutCubic)
                        .blurXY(begin: 8, end: 0),
                  ),
                const SizedBox(height: 10),
                Text('Bill details', style: text.titleMedium)
                    .animate()
                    .fadeIn(delay: 260.ms)
                    .slideX(begin: 0.2, end: 0),
                const SizedBox(height: 12),
                _BillCard(order: order, accent: accent),
                const SizedBox(height: 18),
                _PromoStrip()
                    .animate()
                    .fadeIn(delay: 720.ms, duration: 500.ms)
                    .slideY(begin: 0.4, end: 0, curve: Curves.easeOutBack),
              ],
            ),
          ),
          _PayBar(
            total: order.total,
            accent: accent,
            onPressed: () => Navigator.of(context).pushNamed(
              'payment_method',
              arguments: order,
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final int? count;
  const _Header({required this.title, this.count});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 12, bottom: 2),
            child: GlassIconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icons.arrow_back_ios_new,
            ),
          ),
          Text(title, style: text.headlineMedium),
          const Spacer(),
          if (count != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  '$count ${count == 1 ? 'item' : 'items'}',
                  key: ValueKey(count),
                  style: text.bodySmall,
                ),
              ),
            ),
        ]
            .animate(interval: 90.ms)
            .fadeIn(duration: 400.ms)
            .slideY(begin: -0.6, end: 0, curve: Curves.easeOutBack),
      ),
    );
  }
}

/// One dish in the cart. Its stepper goes down to zero, which removes it.
class _LineCard extends ConsumerWidget {
  final CartLine line;
  final ValueChanged<int> onQty;
  const _LineCard({required this.line, required this.onQty});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final recipe = line.recipe;
    final accent = watchDishAccent(ref, recipe.imageUrl);
    return GlassContainer(
      padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
      borderRadius: BorderRadius.circular(24),
      child: Row(
        children: [
          Hero(
            tag: 'dish-${recipe.id}',
            flightShuttleBuilder: (_, __, ___, ____, toCtx) => toCtx.widget,
            child: SizedBox(
              width: 78,
              height: 78,
              child: Image.asset(recipe.imageUrl, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.name,
                    style: text.titleLarge?.copyWith(fontSize: 20),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('\$${line.unitPrice.toStringAsFixed(2)} each',
                    style: text.labelMedium
                        ?.copyWith(fontSize: 13, color: softAccent(accent))),
                const SizedBox(height: 8),
                QuantityStepper(
                  value: line.quantity,
                  onChanged: onQty,
                  min: 0,
                  accentColor: accent,
                ),
              ],
            ),
          ),
          AnimatedPrice(
            value: line.total,
            style: text.titleLarge?.copyWith(fontSize: 22),
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AnnotatedScaffold(
      child: Column(
        children: [
          const _Header(title: 'Checkout'),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_bag_outlined,
                          size: 72, color: Colors.white38)
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(begin: 0, end: -8, duration: 1600.ms),
                  const SizedBox(height: 16),
                  Text('Your cart is empty', style: text.titleLarge),
                  const SizedBox(height: 6),
                  Text('Add a dish to get started', style: text.bodySmall),
                  const SizedBox(height: 22),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil('home', (r) => r.isFirst),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26)),
                    ),
                    child: const Text('Browse dishes',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms).scaleXY(begin: 0.9, end: 1),
            ),
          ),
        ],
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  final OrderDraft order;
  final Color accent;
  const _BillCard({required this.order, required this.accent});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    Widget row(String label, double value, int i, {bool strong = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: strong
                    ? text.titleLarge
                    : text.bodySmall?.copyWith(fontSize: 15)),
            AnimatedPrice(
              value: value,
              superscript: strong,
              style: strong
                  ? text.titleLarge
                      ?.copyWith(color: softAccent(accent), fontSize: 28)
                  : text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: (340 + i * 90).ms, duration: 400.ms)
          .slideX(begin: 0.15, end: 0, curve: Curves.easeOutCubic);
    }

    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        children: [
          row('Subtotal', order.subtotal, 0),
          row('Delivery fee', order.deliveryFee, 1),
          row('Tax (8%)', order.tax, 2),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: DashedDivider(),
          ),
          row('Total', order.total, 3, strong: true),
        ],
      ),
    );
  }
}

class _PromoStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border:
            Border.all(color: AppColors.timeLineColor.withValues(alpha: 0.5)),
        color: AppColors.timeLineColor.withValues(alpha: 0.08),
      ),
      child: Row(
        children: [
          const Text('🎁', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
                'Free dessert added — chef\'s treat on your first order',
                style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _PayBar extends StatelessWidget {
  final double total;
  final VoidCallback onPressed;
  final Color accent;
  const _PayBar(
      {required this.total, required this.onPressed, required this.accent});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      opacity: 0.6,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total', style: Theme.of(context).textTheme.bodySmall),
              AnimatedPrice(
                value: total,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 28),
              ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: GestureDetector(
              onTap: onPressed,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.lerp(accent, Colors.white, 0.18)!,
                        accent,
                      ],
                    ),
                  ),
                  child: Text(
                    'Proceed to Payment',
                    style: TextStyle(
                        color: onAccent(accent),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2),
                  ),
                ).shineSweep(),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 500.ms, duration: 450.ms)
        .slideY(begin: 1, end: 0, curve: Curves.easeOutCubic);
  }
}
