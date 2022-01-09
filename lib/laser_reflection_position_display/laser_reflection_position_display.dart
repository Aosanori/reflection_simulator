import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../optics_diagram/optics_diagram_viewModel.dart';

class LaserRefalactionPositionListDisplay extends HookConsumerWidget {
  const LaserRefalactionPositionListDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView.builder(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        itemCount: dataList.length,
        itemBuilder: (context, index) =>
            const LaserRefalactionPositionDisplay(),
      );
}

class LaserRefalactionPositionDisplay extends HookConsumerWidget {
  const LaserRefalactionPositionDisplay({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) => LayoutBuilder(
        builder: (context, constraints) => Container(
          padding: const EdgeInsets.all(10),
          width: constraints.maxHeight,
          child: const CustomPaint(
            painter: _MirrorPainter(),
          ),
        ),
      );
}

class _MirrorPainter extends CustomPainter {
  const _MirrorPainter();

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
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10, paint);


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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
