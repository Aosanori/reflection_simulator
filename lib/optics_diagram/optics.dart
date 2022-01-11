import 'dart:math';

import 'package:vector_math/vector_math.dart';

class OpticsPosition {
  OpticsPosition({
    required this.x,
    required this.y,
    required this.z,
    required this.theta,
    required this.phi,
  });

  final double x;
  final double y;
  final double z;
  final double theta;
  final double phi;

  double get thetaRadian => theta * pi / 180;
  double get phiRadian => phi * pi / 180;
  Vector3 get vector => Vector3(x, y, z);
}

// リスト項目のデータ構造
class Optics {
  Optics(this.id, this.name, this.position, [this.size = 12.7]);
  String id;
  String name;
  OpticsPosition position;
  double size;

  Vector3 get normalVector => Vector3(
        sin(position.phiRadian) * cos(position.thetaRadian),
        sin(position.phiRadian) * sin(position.thetaRadian),
        cos(position.phiRadian),
      );
}
