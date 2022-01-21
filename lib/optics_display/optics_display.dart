import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart' as vm;

import '../optics_diagram/optics.dart';
import '../utils/environments_variables.dart';
import '../utils/get_position_of_mirror.dart';
import '../utils/graph.dart';
import 'optics_display_viewModel.dart';

class OpticsDisplay extends HookConsumerWidget {
  const OpticsDisplay({Key? key}) : super(key: key);
  static final transformationController = TransformationController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opticsDisplayViewModel = ref.watch(opticsDisplayViewModelProvider);
    final currentOpticsList = opticsDisplayViewModel.currentOpticsList;
    final currentOpticsTree = opticsDisplayViewModel.currentOpticsTree;
    final simulationResult = opticsDisplayViewModel.simulationResult;
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(25600),
      minScale: 0.1,
      maxScale: 10,
      transformationController: transformationController,
      child: CustomPaint(
        willChange: true,
        painter: _OpticsPainter(
          currentOpticsList: currentOpticsList,
          currentOpticsTree: currentOpticsTree,
          simulationResult: simulationResult,
        ),
      ),
    );
  }
}

class _OpticsPainter extends CustomPainter {
  _OpticsPainter({
    required this.currentOpticsList,
    required this.currentOpticsTree,
    required this.simulationResult,
  });
  final List<Optics> currentOpticsList;
  final Graph<Optics> currentOpticsTree;
  final List<List<Map<int, vm.Vector3>>> simulationResult;

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

    // レーザー線の描画
    for (var branchID = 0; branchID < simulationResult.length; branchID++) {
      paint
        ..color = branchColor[branchID]
        ..strokeWidth = 3;
      for (var i = 1; i < simulationResult[branchID].length; i++) {
        final nodeID = simulationResult[branchID][i].keys.first;
        final optics = currentOpticsTree.nodes.keys.elementAt(nodeID).data;

        final distance = optics.position.vector
            .distanceTo(simulationResult[branchID][i].values.first);
        canvas.drawLine(
          getPositionOfBeam(
              simulationResult[branchID][i - 1].values.first, size),
          getPositionOfBeam(simulationResult[branchID][i].values.first, size),
          paint,
        );
        // ミラーからはみ出したら
        if (distance > optics.size) {
          paint.color = branchColor[branchID].shade50;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
