import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dribbble_challenge/src/checkout/domain/order_draft.dart';

/// A glossy card that reflects the currently selected payment method. When the
/// method changes it does a real Y-axis flip, swapping its face at the midpoint,
/// then rocks gently forever.
class CreditCardVisual extends StatefulWidget {
  final PaymentMethod method;
  const CreditCardVisual({super.key, required this.method});

  @override
  State<CreditCardVisual> createState() => _CreditCardVisualState();
}

class _CreditCardVisualState extends State<CreditCardVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flip = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 520));
  late PaymentMethod _shown = widget.method;

  @override
  void initState() {
    super.initState();
    _flip.forward(); // flip in on first appearance
  }

  @override
  void didUpdateWidget(covariant CreditCardVisual old) {
    super.didUpdateWidget(old);
    if (old.method != widget.method) {
      _flip.forward(from: 0);
      Future.delayed(const Duration(milliseconds: 210), () {
        if (mounted) setState(() => _shown = widget.method);
      });
    }
  }

  @override
  void dispose() {
    _flip.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.62,
      child: AnimatedBuilder(
        animation: _flip,
        builder: (context, _) {
          final t = Curves.easeInOutCubic.transform(_flip.value);
          final angle = t * math.pi; // 0 → π
          final showingBack = angle > math.pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(angle),
            child: Transform(
              // un-mirror the face once we're past 90°
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(showingBack ? math.pi : 0),
              child: _CardFace(method: _shown),
            ),
          );
        },
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .custom(
          delay: 900.ms,
          duration: 3.seconds,
          curve: Curves.easeInOut,
          begin: -1,
          end: 1,
          builder: (context, value, child) => Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateZ(value * 0.012)
              ..rotateY(value * 0.05),
            child: child,
          ),
        );
  }
}

class _CardTheme {
  final List<Color> gradient;
  final Color glow;
  const _CardTheme(this.gradient, this.glow);
}

const _themes = {
  PaymentMethod.visa: _CardTheme(
      [Color(0xff2A2F4F), Color(0xff5B4B8A), Color(0xff8A5FBF)],
      Color(0xff5B4B8A)),
  PaymentMethod.applePay:
      _CardTheme([Color(0xff1C1C1E), Color(0xff2C2C2E), Color(0xff3A3A3C)], Colors.black),
  PaymentMethod.paypal: _CardTheme(
      [Color(0xff003087), Color(0xff0070BA), Color(0xff009CDE)], Color(0xff0070BA)),
  PaymentMethod.cash: _CardTheme(
      [Color(0xff0B6E4F), Color(0xff11835E), Color(0xff14A76C)], Color(0xff14A76C)),
};

class _CardFace extends StatelessWidget {
  final PaymentMethod method;
  const _CardFace({required this.method});

  @override
  Widget build(BuildContext context) {
    final theme = _themes[method]!;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: theme.gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.glow.withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: switch (method) {
        PaymentMethod.visa => _visa(),
        PaymentMethod.applePay => _simple(
            brand: 'Apple Pay',
            icon: Icons.apple,
            primary: '•••• •••• •••• 4291',
            leftLabel: 'ALEX MORGAN',
            rightLabel: 'Face ID',
          ),
        PaymentMethod.paypal => _simple(
            brand: 'PayPal',
            icon: Icons.account_balance_wallet,
            primary: 'alex.morgan@example.com',
            leftLabel: 'BALANCE',
            rightLabel: '\$248.10',
          ),
        PaymentMethod.cash => _simple(
            brand: 'Cash',
            icon: Icons.payments_outlined,
            primary: 'Pay at the door',
            leftLabel: 'NO CARD NEEDED',
            rightLabel: 'On delivery',
          ),
      },
    );
  }

  Widget _visa() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 44,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: const LinearGradient(
                  colors: [Color(0xffE8C35C), Color(0xffB8892E)],
                ),
              ),
            ),
            const Text('VISA',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2)),
          ],
        ),
        const Spacer(),
        const Text('4291  ••••  ••••  7238',
            style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 14),
        _footer('ALEX MORGAN', '08/29'),
      ],
    );
  }

  Widget _simple({
    required String brand,
    required IconData icon,
    required String primary,
    required String leftLabel,
    required String rightLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            Text(brand,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1)),
          ],
        ),
        const Spacer(),
        Text(primary,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 14),
        _footer(leftLabel, rightLabel),
      ],
    );
  }

  Widget _footer(String left, String right) {
    final style = TextStyle(
        color: Colors.white.withValues(alpha: 0.85),
        fontSize: 12,
        letterSpacing: 1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(left, style: style, overflow: TextOverflow.ellipsis)),
        Text(right, style: style),
      ],
    );
  }
}
