import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomDial extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;

  const CustomDial({
    Key? key,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomDialState createState() => _CustomDialState();
}

class _CustomDialState extends State<CustomDial> {
  void _handlePanUpdate(DragUpdateDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localOffset = renderBox.globalToLocal(details.globalPosition);
    final Offset center =
        Offset(renderBox.size.width / 2, renderBox.size.height / 2);
    final double dx = localOffset.dx - center.dx;
    final double dy = localOffset.dy - center.dy;
    double angle = math.atan2(dy, dx) + math.pi / 2;

    // Normalize the angle to be between 0 and 2*pi
    if (angle < 0) angle += 2 * math.pi;

    final double newValue = angle / (2 * math.pi) * 100;
    if (!newValue.isNaN) {
      widget.onChanged?.call(newValue.clamp(0, 100));
    }
  }

  @override
  Widget build(BuildContext context) {
    const double dialSize = 150.0;

    return GestureDetector(
      onPanUpdate: _handlePanUpdate,
      child: CustomPaint(
        painter: _DialPainter(value: widget.value),
        size: Size(dialSize, dialSize), // Use the updated dial size here
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  final double value;

  _DialPainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke
      ..color = Colors.blue.withOpacity(value / 100);

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 1.5,
      (value / 100 * 360).radians,
      false,
      paint,
    );

    final textSpan = TextSpan(
      text: '${value.toInt()}°C',
      style: const TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final textOffset = Offset(center.dx - (textPainter.width / 2),
        center.dy - (textPainter.height / 2));
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

extension MathExtension on num {
  double get radians => this * (math.pi / 180.0);
}
