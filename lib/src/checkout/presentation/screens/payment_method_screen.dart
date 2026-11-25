import 'package:dribbble_challenge/src/core/widget/glass_container.dart';
import 'package:dribbble_challenge/src/core/widget/annotated_scaffold.dart';
import 'package:dribbble_challenge/src/core/widget/morphing_pay_button.dart';
import 'package:dribbble_challenge/src/checkout/domain/order_draft.dart';
import 'package:dribbble_challenge/src/checkout/presentation/screens/payment_success_screen.dart';
import 'package:dribbble_challenge/src/checkout/presentation/widgets/credit_card_visual.dart';
import 'package:dribbble_challenge/src/checkout/presentation/widgets/payment_method_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PaymentMethodScreen extends StatefulWidget {
  final OrderDraft order;
  const PaymentMethodScreen({super.key, required this.order});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentMethod _selected = PaymentMethod.visa;

  static const _successColor = Color(0xff0FA958);

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AnnotatedScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 20, 4),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6, right: 12),
                  child: GlassIconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icons.arrow_back_ios_new,
                  ),
                ),
                Text('Payment', style: text.headlineMedium),
              ]
                  .animate(interval: 90.ms)
                  .fadeIn(duration: 380.ms)
                  .slideY(begin: -0.6, end: 0, curve: Curves.easeOutBack),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              children: [
                CreditCardVisual(method: _selected),
                const SizedBox(height: 26),
                Text('Choose how to pay', style: text.titleMedium)
                    .animate()
                    .fadeIn(delay: 360.ms)
                    .slideX(begin: 0.2, end: 0),
                const SizedBox(height: 12),
                for (var i = 0; i < PaymentMethod.values.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PaymentMethodCard(
                      method: PaymentMethod.values[i],
                      selected: _selected == PaymentMethod.values[i],
                      index: i,
                      onTap: () =>
                          setState(() => _selected = PaymentMethod.values[i]),
                    ),
                  ),
              ],
            ),
          ),
          GlassContainer(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            opacity: 0.6,
            child: MorphingPayButton(
              label: 'Pay \$${widget.order.total.toStringAsFixed(2)}',
              color: _successColor,
              processDuration: const Duration(milliseconds: 1800),
              onComplete: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration:
                        const Duration(milliseconds: 250),
                    pageBuilder: (_, __, ___) => PaymentSuccessScreen(
                      order: widget.order,
                      method: _selected,
                      bgColor: _successColor,
                    ),
                  ),
                );
              },
            ),
          )
              .animate()
              .fadeIn(delay: 480.ms, duration: 420.ms)
              .slideY(begin: 1, end: 0, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }
}
