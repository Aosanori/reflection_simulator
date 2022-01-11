import 'package:flutter/material.dart';
// ignore: directives_ordering
import 'dart:math';
import 'package:vector_math/vector_math.dart';

import 'package:vector_math/vector_math.dart' as vm;

import '../optics_diagram/optics.dart';

List<Offset> getPositionOfMirror(double x, double y, double theta, Size size) {
  // ignore: parameter_assignments
  y *= -1; // y軸が上から下に取られているので逆にする
  const mirrorSize = 50;
  final x1 = (x + 10) + mirrorSize * cos((180 - theta) * pi / 180);
  final y1 = y + size.height / 2 + mirrorSize * sin((180 - theta) * pi / 180);
  final x2 = (x + 10) - mirrorSize * cos((180 - theta) * pi / 180);
  final y2 = y + size.height / 2 - mirrorSize * sin((180 - theta) * pi / 180);
  return [Offset(x1, y1), Offset(x2, y2)];
}

Offset getPositionOfBeam(Vector3 vector, Size size) =>
    Offset(10 + vector.x, -vector.y + size.height / 2);

void drawPositionOfReflection(
  Optics optics,
  vm.Vector3 result,
  Canvas canvas,
  Size size,
  Paint paint,
) {
  final angle = optics.position.vector.angleTo(result);
  final distance = optics.position.vector.distanceTo(result);
  final ratio = distance / optics.size;
  final radius = size.width / 2;
  if (ratio <= 1) {
    canvas.drawCircle(
      Offset(
        size.width / 2 + (radius * ratio * cos(angle)),
        size.height / 2 - (radius * ratio * sin(angle)),
      ),
      10,
      paint,
    );
  }
}
