import 'package:flutter/material.dart';

/// Smoothly tweens a currency value whenever it changes — the digits visibly
/// "roll" from the old amount to the new one.
///
/// By default it's set editorially: a raised, smaller currency symbol and
/// cents ( ˢ12.⁴⁹ ). Pass `superscript: false` for a plain inline amount.
class AnimatedPrice extends StatelessWidget {
  final double value;
  final TextStyle? style;
  final Duration duration;
  final String symbol;
  final bool superscript;

  const AnimatedPrice({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 550),
    this.symbol = '\$',
    this.superscript = true,
  });

  static const _tabular = TextStyle(
    fontFeatures: [FontFeature.tabularFigures()],
  );

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: value, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        final amount = v.toStringAsFixed(2);
        final base =
            DefaultTextStyle.of(context).style.merge(style).merge(_tabular);
        if (!superscript) return Text('$symbol$amount', style: base);

        final [whole, cents] = amount.split('.');
        final size = base.fontSize ?? 14;
        final color = base.color ?? Colors.white;
        final minor = base.copyWith(
          fontSize: size * 0.5,
          height: 1,
          color: color.withValues(alpha: color.a * 0.72),
        );
        // raised to sit level with the cap height of the main digits
        Widget raised(String s) => Padding(
              padding: EdgeInsets.only(top: size * 0.16, left: 1, right: 1),
              child: Text(s, style: minor),
            );

        return Text.rich(
          TextSpan(children: [
            WidgetSpan(
                alignment: PlaceholderAlignment.top, child: raised(symbol)),
            TextSpan(text: whole),
            WidgetSpan(
                alignment: PlaceholderAlignment.top, child: raised('.$cents')),
          ]),
          style: base,
        );
      },
    );
  }
}
