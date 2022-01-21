import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart' as vm;

import '../optics_diagram/optics.dart';
import '../utils/environments_variables.dart';
import '../utils/get_position_of_mirror.dart';
import 'beam_reflection_position_list_display_viewModel.dart';

class BeamReflectionPositionListDisplay extends HookConsumerWidget {
  const BeamReflectionPositionListDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel =
        ref.watch(beamReflectionPositionListDisplayViewModelProvider);
    final result = viewModel.simulationResult;
    return ListView.builder(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      itemCount: result.length,
      itemBuilder: (context, index) {
        if (result.keys.elementAt(index) is Mirror) {
          return _BeamReflectionPositionDisplay(
            result: {
              result.keys.elementAt(index): result.values.elementAt(index)
            },
          );
        }
        return Container();
      },
    );
  }
}

class _BeamReflectionPositionDisplay extends StatelessWidget {
  const _BeamReflectionPositionDisplay({required this.result, Key? key})
      : super(key: key);
  final Map<Optics, List<vm.Vector3>> result;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => Container(
          padding: const EdgeInsets.all(10),
          width: constraints.maxHeight,
          child: CustomPaint(
            painter: _MirrorPainter(result: result),
          ),
        ),
      );
}

class _MirrorPainter extends CustomPainter {
  const _MirrorPainter({required this.result});
  final Map<Optics, List<vm.Vector3>> result;

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

    final optics = result.keys.first;
    // 中心点（塗りつぶし）
    for (var i = 0; i < result.values.first.length; i++) {
      paint.color = branchColor[i];
      final position = result.values.first[i];
      drawPositionOfReflection(optics, position, canvas, size, paint);
    }
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
      ..paint(canvas, const Offset(-10, 0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
