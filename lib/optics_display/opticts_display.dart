import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reflection_simulator/optics_diagram/optics_diagram_viewModel.dart';
import 'dart:math';

class OpticsDisplay extends HookConsumerWidget {
  const OpticsDisplay({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) => CustomPaint(
        painter: _OpticsPainter(),
      );
}

List<Offset> getPositionOfMirror(double x, double y, double theta, Size size) {
  y *= -1; // y軸が上から下に取られているので逆にする
  const mirror_size = 50;
  final x1 = (x + 10) + mirror_size * cos((180 - theta) * pi / 180);
  final y1 = y + size.height / 2 + mirror_size * sin((180 - theta) * pi / 180);
  final x2 = (x + 10) - mirror_size * cos((180 - theta) * pi / 180);
  final y2 = y + size.height / 2 - mirror_size * sin((180 - theta) * pi / 180);
  return [Offset(x1, y1), Offset(x2, y2)];
}

class _OpticsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Offset(x,y)
    final paint = Paint();
    for (final data in dataList) {
      paint
        ..color = Colors.grey
        ..strokeWidth = 5;
      final positions = getPositionOfMirror(
          data.position.x, data.position.y, data.position.theta, size);
      canvas.drawLine(
        positions[0],
        positions[1],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
