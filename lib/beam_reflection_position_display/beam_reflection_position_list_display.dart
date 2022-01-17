import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart' as vm;

import '../optics_diagram/optics.dart';
import '../utils/get_position_of_mirror.dart';
import 'beam_reflection_position_list_display_viewModel.dart';

class BeamReflectionPositionListDisplay extends HookConsumerWidget {
  const BeamReflectionPositionListDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beamReflectionPositionListDisplayViewModel =
        ref.watch(beamReflectionPositionListDisplayViewModelProvider);
    return ListView.builder(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      itemCount:
          beamReflectionPositionListDisplayViewModel.currentOpticsList.length,
      itemBuilder: (context, index) =>
          BeamReflectionPositionDisplay(index: index),
    );
  }
}

class BeamReflectionPositionDisplay extends HookConsumerWidget {
  const BeamReflectionPositionDisplay({required this.index, Key? key})
      : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beamReflectionPositionListDisplayViewModel =
        ref.watch(beamReflectionPositionListDisplayViewModelProvider);
    final optics =
        beamReflectionPositionListDisplayViewModel.currentOpticsList[index];
    final result =
        beamReflectionPositionListDisplayViewModel.simulationResult[index + 1];
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        padding: const EdgeInsets.all(10),
        width: constraints.maxHeight,
        child: CustomPaint(
          painter: _MirrorPainter(optics: optics, result: result),
        ),
      ),
    );
  }
}

class _MirrorPainter extends CustomPainter {
  const _MirrorPainter({required this.optics, required this.result});
  final Optics optics;
  final vm.Vector3 result;
  // 左上が(0,0)
  // 中心を基準 => Offset(size.width / 2, size.height / 2)

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;
    // 十字線
    canvas
      ..drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        paint,
      )
      ..drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        paint,
      );

    // 中心点（塗りつぶし）
    paint.color = Colors.red;
    drawPositionOfReflection(optics, result, canvas, size, paint);

    // 円（外線） 一応 反射鏡
    final line = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      line,
    );

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
    TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )
      ..layout(
        maxWidth: 50,
      )
      ..paint(canvas, const Offset(-10,0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
