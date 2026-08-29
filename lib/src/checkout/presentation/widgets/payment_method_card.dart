import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dribbble_challenge/src/core/theme/app_colors.dart';
import 'package:dribbble_challenge/src/checkout/domain/order_draft.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod method;
  final bool selected;
  final int index;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.selected,
    required this.index,
    required this.onTap,
  });

  static const _icons = {
    PaymentMethod.visa: Icons.credit_card,
    PaymentMethod.applePay: Icons.apple,
    PaymentMethod.paypal: Icons.account_balance_wallet,
    PaymentMethod.cash: Icons.payments_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedScale(
        scale: selected ? 1.03 : 1,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? AppColors.timeLineColor
                  : Colors.white.withValues(alpha: 0.08),
              width: selected ? 2 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.timeLineColor.withValues(alpha: 0.35),
                      blurRadius: 22,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_icons[method], color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(method.label, style: text.titleMedium),
                    const SizedBox(height: 2),
                    Text(method.detail, style: text.bodySmall),
                  ],
                ),
              ),
              _Radio(selected: selected),
            ],
          ),
        ),
      ),
    )
        .animate(delay: (420 + index * 110).ms)
        .custom(
          duration: 560.ms,
          curve: Curves.easeOutBack,
          begin: 1,
          end: 0,
          builder: (context, value, child) => Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(-value * 1.15),
            child: Opacity(opacity: (1 - value).clamp(0.0, 1.0), child: child),
          ),
        )
        .slideY(begin: 0.3, end: 0, duration: 460.ms, curve: Curves.easeOutCubic);
  }
}

class _Radio extends StatelessWidget {
  final bool selected;
  const _Radio({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.timeLineColor : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.timeLineColor : Colors.white38,
          width: 2,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 15, color: Colors.black)
              .animate()
              .scaleXY(begin: 0, end: 1, curve: Curves.easeOutBack, duration: 260.ms)
              .rotate(begin: -0.1, end: 0)
          : null,
    );
  }
}
