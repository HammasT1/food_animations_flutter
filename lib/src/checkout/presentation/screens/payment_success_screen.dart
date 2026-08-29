import 'dart:async';
import 'package:dribbble_challenge/src/core/theme/app_colors.dart';
import 'package:dribbble_challenge/src/core/widget/animated_checkmark.dart';
import 'package:dribbble_challenge/src/core/widget/animated_price.dart';
import 'package:dribbble_challenge/src/core/widget/confetti_overlay.dart';
import 'package:dribbble_challenge/src/core/widget/dashed_divider.dart';
import 'package:dribbble_challenge/src/checkout/domain/order_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final OrderDraft order;
  final PaymentMethod method;
  final Color bgColor;

  const PaymentSuccessScreen({
    super.key,
    required this.order,
    required this.method,
    this.bgColor = const Color(0xff0FA958),
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  bool _confetti = false;
  bool _amount = false;
  late final String _orderId = widget.order.orderId;
  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();
    _timers.add(Timer(const Duration(milliseconds: 550), () {
      if (mounted) setState(() => _confetti = true);
      HapticFeedback.mediumImpact();
    }));
    _timers.add(Timer(const Duration(milliseconds: 950), () {
      if (mounted) setState(() => _amount = true);
    }));
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: widget.bgColor,
      body: Stack(
        children: [
          // gentle vignette so the flat colour has depth
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 1.1,
                colors: [Color(0x22FFFFFF), Colors.transparent],
              ),
            ),
            child: SizedBox.expand(),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),
                Container(
                  width: 148,
                  height: 148,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: AnimatedCheckmark(
                    size: 96,
                    color: widget.bgColor,
                    ringColor: widget.bgColor,
                  ),
                )
                    .animate()
                    .scale(
                        begin: const Offset(0, 0),
                        end: const Offset(1, 1),
                        duration: 600.ms,
                        curve: Curves.elasticOut)
                    .animate(
                        onPlay: (c) => c.repeat(reverse: true), delay: 700.ms)
                    .moveY(begin: 0, end: -8, duration: 2.seconds, curve: Curves.easeInOut),
                const SizedBox(height: 28),
                Text('Payment Successful!',
                        style: text.displaySmall?.copyWith(fontSize: 26))
                    .animate()
                    .fadeIn(delay: 450.ms, duration: 450.ms)
                    .slideY(begin: 0.4, end: 0, curve: Curves.easeOutBack)
                    .blurXY(begin: 6, end: 0),
                const SizedBox(height: 8),
                Text(
                  'Your order is confirmed and on its way',
                  style: text.bodySmall?.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 620.ms, duration: 400.ms),
                const Spacer(flex: 1),
                _ReceiptCard(
                  order: widget.order,
                  method: widget.method,
                  orderId: _orderId,
                  showAmount: _amount,
                ),
                const SizedBox(height: 16),
                _Actions(bgColor: widget.bgColor),
                const SizedBox(height: 10),
              ],
            ),
          ),
          if (_confetti)
            const Positioned.fill(
              child: IgnorePointer(child: ConfettiOverlay()),
            ),
        ],
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final OrderDraft order;
  final PaymentMethod method;
  final String orderId;
  final bool showAmount;

  const _ReceiptCard({
    required this.order,
    required this.method,
    required this.orderId,
    required this.showAmount,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    Widget line(String k, Widget v, int i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(k, style: text.bodySmall),
              DefaultTextStyle(
                style: text.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                child: v,
              ),
            ],
          ),
        ).animate().fadeIn(delay: (1050 + i * 110).ms).slideX(begin: 0.12, end: 0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: DashedDivider(),
          ),
          line(
            'Amount paid',
            AnimatedPrice(
              value: showAmount ? order.total : 0,
              duration: const Duration(milliseconds: 900),
              style: text.titleLarge?.copyWith(
                  color: AppColors.timeLineColor, fontWeight: FontWeight.bold),
            ),
            0,
          ),
          line('Order ID', Text(orderId), 1),
          line('Estimated delivery', Text('${order.etaMinutes} min'), 2),
          line('Paid with', Text(method.label), 3),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 800.ms, duration: 450.ms)
        .slideY(begin: 0.6, end: 0, curve: Curves.easeOutCubic);
  }
}

class _Actions extends StatelessWidget {
  final Color bgColor;
  const _Actions({required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
              ),
              child: const Text('Track Order',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil('home', (r) => r.isFirst),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: bgColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
              ),
              child: const Text('Back to Home',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 1250.ms, duration: 450.ms)
        .slideY(begin: 0.8, end: 0, curve: Curves.easeOutBack);
  }
}
