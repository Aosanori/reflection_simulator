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
    startPosionVector = startFrom.vector;
    ray = Ray.originDirection(
      startPosionVector,
      direction,
    );
  }

  String type;
  num waveLength;
  num beamWaist;
  final OpticsPosition startFrom;
  double distanceFromStart = 0;
  late Vector3 startPosionVector;
  late Ray ray;

  late Vector3 direction = Vector3(
    sin(startFrom.phiRadian) * cos(startFrom.thetaRadian),
    sin(startFrom.phiRadian) * sin(startFrom.thetaRadian),
    cos(startFrom.phiRadian),
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
    distanceFromStart += nextStartPoint.distanceTo(startPosionVector);
    direction = reflectVector(optics);
    ray = Ray.originDirection(
      nextStartPoint,
      direction,
    );
    startPosionVector = nextStartPoint;
    print(nextStartPoint);
    return nextStartPoint;
  }
}
