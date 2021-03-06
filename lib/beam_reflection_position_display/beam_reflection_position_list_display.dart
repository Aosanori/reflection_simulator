import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart' as vm;

import '../beam_information/beam.dart';
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
    final beams = viewModel.simulatedBeamList;
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
            beams: beams,
          );
        }
        return Container();
      },
    );
  }
}

class _BeamReflectionPositionDisplay extends StatelessWidget {
  const _BeamReflectionPositionDisplay(
      {required this.result, required this.beams, Key? key})
      : super(key: key);
  final Map<Optics, Map<int, vm.Vector3>> result;
  final List<Beam> beams;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => Container(
          padding: const EdgeInsets.all(10),
          width: constraints.maxHeight,
          child: CustomPaint(
            painter: _MirrorPainter(result: result, beams: beams),
          ),
        ),
      );
}

class _MirrorPainter extends CustomPainter {
  const _MirrorPainter({required this.result, required this.beams});
  final Map<Optics, Map<int, vm.Vector3>> result;
  final List<Beam> beams;

  // ?????????(0,0)
  // ??????????????? => Offset(size.width / 2, size.height / 2)

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;
    // ?????????
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

    // ??????????????? ?????? ?????????
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
    // ??????????????????????????????
    result[optics]?.forEach(
      (i, position) {
        paint.color = branchColor[i];
        final position = result.values.first[i]!;
        final beamWaist = beams[i].beamWaistOn[optics] ?? 0.0;
        drawPositionOfReflection(
          optics,
          position,
          canvas,
          size,
          paint,
          beamWaist,
        );
      },
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

    // ???????????????????????????????????????
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
