import 'dart:math';

import 'package:vector_math/vector_math.dart';

// リスト項目のデータ構造
abstract class Optics {
  Optics({
    required this.id,
    required this.name,
    required this.position,
    this.size = 12.7,
  });
  String id;
  String name;
  OpticsPosition position;
  double size;
  late String type;

  void copy();

  Vector3 get normalVector => Vector3(
        sin(position.phiRadian) * cos(position.thetaRadian),
        sin(position.phiRadian) * sin(position.thetaRadian),
        cos(position.phiRadian),
      );
}

class OpticsPosition {
  OpticsPosition({
    required this.x,
    required this.y,
    required this.z,
    required this.theta,
    required this.phi,
  });

  double x;
  double y;
  double z;
  double theta;
  double phi;

  double get thetaRadian => theta * pi / 180;
  double get phiRadian => phi * pi / 180;
  Vector3 get vector => Vector3(x, y, z);
}

class PolarizingBeamSplitter extends Optics {
  PolarizingBeamSplitter(
    String id,
    String name,
    OpticsPosition position,
  ) : super(
          id: id,
          name: name,
          position: position,
        );

  @override
  final type = 'PBS';

  @override
  PolarizingBeamSplitter copy() => PolarizingBeamSplitter(
        id,
        name,
        position,
      );
}

class Mirror extends Optics {
  Mirror(
    String id,
    String name,
    OpticsPosition position,
  ) : super(
          id: id,
          name: name,
          position: position,
        );

  @override
  final type = 'Mirror';

  @override
  Mirror copy() => Mirror(
        id,
        name,
        position,
      );
}
