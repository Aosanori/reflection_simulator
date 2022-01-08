import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OpticsDisplay extends HookConsumerWidget {
  const OpticsDisplay({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomPaint(
      painter: _SamplePainter(),
    );
  }
}

class _SamplePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;
    canvas.drawRect(Rect.fromLTWH(0, 0, 50, 50), paint);
    paint.color = Colors.grey;
    paint.strokeWidth = 5;
    canvas.drawLine(Offset(140, 10), Offset(140, 60), paint);
    paint.color = Colors.red;
    canvas.drawCircle(Offset(100, 35), 25, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}