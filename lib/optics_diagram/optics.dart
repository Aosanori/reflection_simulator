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
}

// リスト項目のデータ構造
class Optics {
  Optics(this.id, this.name, this.position);
  String id;
  String name;
  OpticsPosition position;

  Vector3 get normalVector => Vector3(
        sin(position.phiRadian) * cos(position.thetaRadian),
        sin(position.phiRadian) * sin(position.thetaRadian),
        cos(position.phiRadian),
      );
}
