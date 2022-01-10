import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/environments_variables.dart';
import '../utils/get_position_of_mirror.dart';

class OpticsDisplay extends HookConsumerWidget {
  const OpticsDisplay({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) => CustomPaint(
        painter: _OpticsPainter(),
      );
}

class _OpticsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Offset(x,y)
    final paint = Paint();
    for (final optics in opticsList) {
      paint
        ..color = Colors.grey
        ..strokeWidth = 5;
      final positions = getPositionOfMirror(
          optics.position.x, optics.position.y, optics.position.theta, size,);
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
