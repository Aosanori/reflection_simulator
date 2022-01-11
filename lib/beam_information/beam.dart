import 'dart:math';

import 'package:vector_math/vector_math.dart';

import '../optics_diagram/optics.dart';

class Beam {
  Beam({
    required this.type,
    required this.waveLength,
    required this.beamWaist,
    required this.startFrom,
  });

  String type;
  num waveLength;
  num beamWaist;
  OpticsPosition startFrom;

  Vector3 get vector => Vector3(
        sin(startFrom.phiRadian) * cos(startFrom.thetaRadian),
        sin(startFrom.phiRadian) * sin(startFrom.thetaRadian),
        cos(startFrom.phiRadian),
      );

  Vector3 reflect(Optics optics) => vector.reflected(optics.normalVector);
}
