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
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(25600),
      minScale: 0.1,
      maxScale: 10,
      transformationController: opticsDisplayViewModel.transformationController,
      child: CustomPaint(
        willChange: true,
        painter: _OpticsPainter(
          currentOpticsList: currentOpticsList,
          simulationResult: simulationResult,
        ),
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

  void _drawOptics(Paint paint, Canvas canvas, Optics optics, Size size) {
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

  void _drawOpticsName(Canvas canvas, Optics optics, Size size) {
    final textSpan = TextSpan(
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        height: 1.2,
        overflow: TextOverflow.ellipsis,
      ),
      children: <TextSpan>[
        TextSpan(text: optics.name),
      ],
    );

    // テキスト描画用のペインター
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(
        maxWidth: 50,
      );

    final positions = getPositionOfMirror(
      optics.position.x,
      optics.position.y,
      // thetaは法線方向を表すので90たす
      optics.position.theta,
      size,
    );
    // テキストの描画
    final offset = positions[0];
    textPainter.paint(canvas, offset);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Offset(x,y)
    final paint = Paint();
    for (final optics in currentOpticsList) {
      _drawOptics(paint, canvas, optics, size);
      _drawOpticsName(canvas, optics, size);
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
