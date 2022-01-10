import 'package:flutter/material.dart';
// ignore: directives_ordering
import 'dart:math';

List<Offset> getPositionOfMirror(double x, double y, double theta, Size size) {
  y *= -1; // y軸が上から下に取られているので逆にする
  const mirror_size = 50;
  final x1 = (x + 10) + mirror_size * cos((180 - theta) * pi / 180);
  final y1 = y + size.height / 2 + mirror_size * sin((180 - theta) * pi / 180);
  final x2 = (x + 10) - mirror_size * cos((180 - theta) * pi / 180);
  final y2 = y + size.height / 2 - mirror_size * sin((180 - theta) * pi / 180);
  return [Offset(x1, y1), Offset(x2, y2)];
}
