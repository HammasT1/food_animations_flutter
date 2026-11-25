import 'dart:ui';

import 'package:dribbble_challenge/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Clips [child] to a rounded rect and blurs whatever is painted behind it.
/// The bare "frost" layer — pair it with a translucent fill to get glass.
class GlassBlur extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final double blur;

  const GlassBlur({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.blur = 18,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: child,
      ),
    );
  }
}

/// A frosted-glass surface: backdrop blur, translucent tint, a soft diagonal
/// sheen and a hairline border that catches light on its top-left edge.
class GlassContainer extends StatelessWidget {
  final Widget? child;
  final BorderRadius borderRadius;
  final double blur;
  final Color tint;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  /// Solid border override (e.g. a selected state). Defaults to the
  /// light-catching gradient edge.
  final Color? borderColor;
  final double borderWidth;

  const GlassContainer({
    super.key,
    this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.blur = 18,
    this.tint = AppColors.cardColor,
    this.opacity = 0.55,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.alignment,
    this.borderColor,
    this.borderWidth = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    Widget glass = GlassBlur(
      borderRadius: borderRadius,
      blur: blur,
      child: CustomPaint(
        foregroundPainter: _GlassBorderPainter(
          borderRadius: borderRadius,
          width: borderWidth,
          color: borderColor,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tint.withValues(alpha: opacity),
            borderRadius: borderRadius,
          ),
          child: Container(
            width: width,
            height: height,
            padding: padding,
            alignment: alignment,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.10),
                  Colors.white.withValues(alpha: 0.02),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
    if (margin != null) glass = Padding(padding: margin!, child: glass);
    return glass;
  }
}

/// Round glass button for app-bar actions (back, favourite, …).
class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final Color? iconColor;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 44,
    this.iconSize = 20,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size / 2);
    return GlassContainer(
      width: size,
      height: size,
      borderRadius: radius,
      opacity: 0.4,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: onPressed,
          child: Icon(icon, size: iconSize, color: iconColor ?? Colors.white),
        ),
      ),
    );
  }
}

class _GlassBorderPainter extends CustomPainter {
  final BorderRadius borderRadius;
  final double width;
  final Color? color;

  _GlassBorderPainter({
    required this.borderRadius,
    required this.width,
    this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect).deflate(width / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    if (color != null) {
      paint.color = color!;
    } else {
      paint.shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.38),
          Colors.white.withValues(alpha: 0.06),
          Colors.white.withValues(alpha: 0.16),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(rect);
    }
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_GlassBorderPainter old) =>
      old.color != color ||
      old.width != width ||
      old.borderRadius != borderRadius;
}
