import 'package:dribbble_challenge/src/core/theme/app_colors.dart';
import 'package:dribbble_challenge/src/core/widget/animated_price.dart';
import 'package:dribbble_challenge/src/core/widget/annotated_scaffold.dart';
import 'package:dribbble_challenge/src/core/widget/dashed_divider.dart';
import 'package:dribbble_challenge/src/checkout/domain/order_draft.dart';
import 'package:dribbble_challenge/src/checkout/presentation/widgets/quantity_stepper.dart';
import 'package:dribbble_challenge/src/recipes/domain/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CheckoutScreen extends StatefulWidget {
  final Recipe recipe;
  const CheckoutScreen({super.key, required this.recipe});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late final OrderDraft _order = OrderDraft(recipe: widget.recipe);

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AnnotatedScaffold(
      child: Column(
        children: [
          const _Header(title: 'Checkout'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              children: [
                _OrderCard(
                  order: _order,
                  onQty: (q) => setState(() => _order.quantity = q),
                )
                    .animate()
                    .fadeIn(delay: 120.ms, duration: 450.ms)
                    .slideY(begin: 0.25, end: 0, curve: Curves.easeOutCubic)
                    .blurXY(begin: 8, end: 0),
                const SizedBox(height: 22),
                Text('Bill details', style: text.titleMedium)
                    .animate()
                    .fadeIn(delay: 260.ms)
                    .slideX(begin: 0.2, end: 0),
                const SizedBox(height: 12),
                _BillCard(order: _order),
                const SizedBox(height: 18),
                _PromoStrip()
                    .animate()
                    .fadeIn(delay: 720.ms, duration: 500.ms)
                    .slideY(begin: 0.4, end: 0, curve: Curves.easeOutBack),
              ],
            ),
          ),
          _PayBar(
            total: _order.total,
            onPressed: () => Navigator.of(context).pushNamed(
              'payment_method',
              arguments: _order,
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          ),
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
        ]
            .animate(interval: 90.ms)
            .fadeIn(duration: 400.ms)
            .slideY(begin: -0.6, end: 0, curve: Curves.easeOutBack),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderDraft order;
  final ValueChanged<int> onQty;
  const _OrderCard({required this.order, required this.onQty});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Hero(
                tag: 'dish-${order.recipe.id}',
                flightShuttleBuilder: (_, __, ___, ____, toCtx) => toCtx.widget,
                child: SizedBox(
                  width: 92,
                  height: 92,
                  child: Image.asset(order.recipe.imageUrl, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.recipe.name,
                        style: text.titleLarge, maxLines: 2),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.schedule,
                            size: 15, color: Colors.white54),
                        const SizedBox(width: 4),
                        Text('Ready in ${order.etaMinutes} min',
                            style: text.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('\$${order.unitPrice.toStringAsFixed(2)} each',
                        style: text.labelMedium?.copyWith(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quantity', style: text.titleMedium),
              QuantityStepper(value: order.quantity, onChanged: onQty),
            ],
          ),
        ],
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  final OrderDraft order;
  const _BillCard({required this.order});

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
              style: strong
                  ? text.titleLarge?.copyWith(
                      color: AppColors.onBoardingButtonColor,
                      fontWeight: FontWeight.bold)
                  : text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: (340 + i * 90).ms, duration: 400.ms)
          .slideX(begin: 0.15, end: 0, curve: Curves.easeOutCubic);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
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
        border: Border.all(color: AppColors.timeLineColor.withValues(alpha: 0.5)),
        color: AppColors.timeLineColor.withValues(alpha: 0.08),
      ),
      child: Row(
        children: [
          const Text('🎁', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text('Free dessert added — chef\'s treat on your first order',
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
  const _PayBar({required this.total, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, -6)),
        ],
      ),
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
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: GestureDetector(
              onTap: onPressed,
              child: Container(
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.onBoardingButtonColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onBoardingButtonColor
                          .withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Text(
                  'Proceed to Payment',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
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
