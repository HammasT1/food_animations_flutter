import 'package:flutter/material.dart';

/// A horizontal dashed rule — used for the perforated edge of the receipt card.
class DashedDivider extends StatelessWidget {
  final Color color;
  final double dash;
  final double gap;
  final double thickness;

  const DashedDivider({
    super.key,
    this.color = Colors.white24,
    this.dash = 6,
    this.gap = 5,
    this.thickness = 2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: thickness,
      child: CustomPaint(
        size: Size.infinite,
        painter: _DashPainter(color, dash, gap, thickness),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  final Color color;
  final double dash, gap, thickness;
  _DashPainter(this.color, this.dash, this.gap, this.thickness);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, size.height / 2),
          Offset((x + dash).clamp(0, size.width), size.height / 2), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) => old.color != color;
}
