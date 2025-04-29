import 'dart:math';
import 'package:flutter/material.dart';

class CircularTimer extends StatefulWidget {
  final void Function(int minutes)? onMinutesChanged;
  final bool isDraggable;
  final bool isBreakTime;

  const CircularTimer({
    super.key,
    this.isDraggable = true,
    this.onMinutesChanged,
    this.isBreakTime = false,
  });

  @override
  State<CircularTimer> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer> {
  double angle = 0;
  Offset center = Offset.zero;
  double radius = 0;

  @override
  Widget build(BuildContext context) {
    final Color timerColor =
        widget.isBreakTime ? Colors.blueAccent : Colors.deepPurple;

    return Opacity(
      opacity: widget.isDraggable ? 1.0 : 0.5,
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth;
            center = Offset(size / 2, size / 2);
            radius = size / 2;

            int minutes = (angle / 360 * 60).round();
            if (minutes == 0) minutes = 60;

            return Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: _CircularTimerPainter(
                    angle: angle,
                    color: timerColor,
                  ),
                  size: Size(size, size),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.isBreakTime
                          ? '쉬는 시간!'
                          : '${minutes.toString().padLeft(2, '0')}:00',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isDraggable) return;

    final touchPosition = details.localPosition;
    final dx = touchPosition.dx - center.dx;
    final dy = touchPosition.dy - center.dy;
    double radians = atan2(dy, dx);

    double newAngle = (radians * 180 / pi + 90) % 360;
    if (newAngle < 0) newAngle += 360;

    double snappedAngle = (newAngle / 6).round() * 6;
    int minutes = (snappedAngle / 360 * 60).round();
    if (minutes == 0) minutes = 60;

    widget.onMinutesChanged?.call(minutes);

    setState(() {
      angle = snappedAngle;
    });
  }
}

class _CircularTimerPainter extends CustomPainter {
  final double angle;
  final Color color;

  _CircularTimerPainter({required this.angle, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;

    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    final foregroundPaint = Paint()
      ..color = color
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - 20, backgroundPaint);

    double sweepAngle = 2 * pi * (angle / 360);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 20),
      -pi / 2,
      sweepAngle,
      false,
      foregroundPaint,
    );

    final double radians = (angle - 90) * pi / 180;
    final handleRadius = 12.0;
    final handleX = center.dx + (radius - 20) * cos(radians);
    final handleY = center.dy + (radius - 20) * sin(radians);

    final handlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final handleBorderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(Offset(handleX, handleY), handleRadius, handlePaint);
    canvas.drawCircle(
        Offset(handleX, handleY), handleRadius, handleBorderPaint);

    for (int i = 0; i < 60; i++) {
      double tickRadians = (i * 6 - 90) * pi / 180;
      final double tickLength = (i % 5 == 0) ? 10 : 5;

      final Offset start = Offset(
        center.dx + (radius + 5) * cos(tickRadians),
        center.dy + (radius + 5) * sin(tickRadians),
      );
      final Offset end = Offset(
        center.dx + (radius + 5 - tickLength) * cos(tickRadians),
        center.dy + (radius + 5 - tickLength) * sin(tickRadians),
      );

      final Paint tickPaint = Paint()
        ..color = Colors.black54
        ..strokeWidth = 2;

      canvas.drawLine(start, end, tickPaint);

      if (i % 5 == 0) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${i == 0 ? '0' : i}',
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        )..layout();

        final labelX = center.dx + (radius + 15) * cos(tickRadians);
        final labelY = center.dy + (radius + 15) * sin(tickRadians);

        textPainter.paint(
          canvas,
          Offset(
            labelX - textPainter.width / 2,
            labelY - textPainter.height / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CircularTimerPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.color != color;
  }
}
