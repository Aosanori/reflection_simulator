import 'dart:math';

import 'package:vector_math/vector_math.dart';

import '../optics_diagram/optics.dart';

class Beam {
  Beam({
    required this.type,
    required this.waveLength,
    required this.beamWaist,
    required this.startFrom,
  }) {
    startPositionVector = startFrom.vector;
    ray = Ray.originDirection(
      startPositionVector,
      direction,
    );
  }

  Beam copy() => Beam(
        type: type,
        waveLength: waveLength,
        beamWaist: beamWaist,
        startFrom: startFrom.copy(),
      );

  String type;
  num waveLength; // nm
  num beamWaist; // mm
  final OpticsPosition startFrom;
  double distanceFromStart = 0;
  late Vector3 startPositionVector;
  late Ray ray;

  List<Optics> passedOptics = [];

  late Vector3 direction = Vector3(
    sin(startFrom.phiRadian) * cos(startFrom.thetaRadian),
    sin(startFrom.phiRadian) * sin(startFrom.thetaRadian),
    cos(startFrom.phiRadian),
  );

  double get rayleighRange => // m
      (pi * beamWaist * pow(10, -3) * beamWaist * pow(10, -3)) /
      (waveLength * pow(10, -9));
  double get currentBeamWaist =>
      beamWaist *
      sqrt(
        1 +
            (distanceFromStart * pow(10, -3) / rayleighRange) *
                (distanceFromStart * pow(10, -3) / rayleighRange),
      );

  Vector3 reflectVector(Optics optics) =>
      direction.reflected(optics.normalVector);

  // 三分探索で求める
  Vector3 pointOfReflection(Optics optics) {
    final constant = -optics.position.vector.dot(optics.normalVector);
    final plane = Plane.normalconstant(optics.normalVector, constant);

    var left = -100000000.0;
    var right = 100000000.0;
    while (right - left > 0.000001) {
      final x1 = (left * 2 + right) / 3.0;
      final x2 = (left + right * 2) / 3.0;

      final rayX1 = ray.at(x1);
      final rayX2 = ray.at(x2);

      final distX1 = plane.distanceToVector3(rayX1).abs();
      final distX2 = plane.distanceToVector3(rayX2).abs();

      if (distX1 < distX2) {
        right = x2;
      } else {
        left = x1;
      }
    }
    return ray.at(left);
  }

  bool canReflect(Optics optics) {
    final distanceToCenter =
        pointOfReflection(optics).distanceTo(optics.position.vector);
    print('$distanceToCenter mm');
    return distanceToCenter <= optics.size;
  }

  //更新処理
  Vector3 reflect(Optics optics) {
    final nextStartPoint = pointOfReflection(optics);
    distanceFromStart += nextStartPoint.distanceTo(startPositionVector);
    direction = reflectVector(optics);
    ray = Ray.originDirection(
      nextStartPoint,
      direction,
    );
    startPositionVector = nextStartPoint;
    passedOptics.add(optics);
    return nextStartPoint;
  }

  // 反射しない場合
  void reachTo(Optics optics) {
    final nextStartPoint = pointOfReflection(optics);
    distanceFromStart += nextStartPoint.distanceTo(startPositionVector);
    ray = Ray.originDirection(
      nextStartPoint,
      direction,
    );
    startPositionVector = nextStartPoint;
    passedOptics.add(optics);
  }
}
