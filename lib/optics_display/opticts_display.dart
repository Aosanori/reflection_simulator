import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart' as vm;

import '../optics_diagram/optics.dart';
import '../utils/get_position_of_mirror.dart';
import 'optics_display_viewModel.dart';

class OpticsDisplay extends HookConsumerWidget {
  const OpticsDisplay({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opticsDisplayViewModel = ref.watch(opticsDisplayViewModelProvider);
    final currentOpticsList = opticsDisplayViewModel.currentOpticsList;
    final simulationResult = opticsDisplayViewModel.simulationResult;
    return CustomPaint(
      willChange: true,
      painter: _OpticsPainter(
        currentOpticsList: currentOpticsList,
        simulationResult: simulationResult,
      ),
    );
  }
}

class _OpticsPainter extends CustomPainter {
  _OpticsPainter({
    required this.currentOpticsList,
    required this.simulationResult,
  });
  final List<Optics> currentOpticsList;
  final List<vm.Vector3> simulationResult;

  @override
  void paint(Canvas canvas, Size size) {
    // Offset(x,y)
    final paint = Paint();
    for (final optics in currentOpticsList) {
      paint
        ..color = Colors.grey
        ..strokeWidth = 5;
      final positions = getPositionOfMirror(
        optics.position.x,
        optics.position.y,
        // thetaは法線方向を表すので90たす
        optics.position.theta + 90,
        size,
      );
      canvas.drawLine(
        positions[0],
        positions[1],
        paint,
      );
    }
    paint
      ..color = Colors.red
      ..strokeWidth = 3;
    for (var i = 1; i < simulationResult.length; i++) {
      final distance = currentOpticsList[i - 1]
          .position
          .vector
          .distanceTo(simulationResult[i]);

      canvas.drawLine(
        getPositionOfBeam(simulationResult[i - 1], size),
        getPositionOfBeam(simulationResult[i], size),
        paint,
      );
      // ミラーからはみ出したら
      if (distance > currentOpticsList[i - 1].size) {
        paint.color = Colors.red.shade50;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
