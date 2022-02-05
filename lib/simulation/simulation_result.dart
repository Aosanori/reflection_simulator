import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart';

import '../beam_information/beam.dart';

@immutable
class SimulationResult {
  const SimulationResult(
    this.reflectionPositions,
    this.simulatedBeamList,
  );
  final List<List<Map<String, Vector3>>> reflectionPositions;
  final List<Beam> simulatedBeamList;

  SimulationResult copy() => SimulationResult(
        reflectionPositions
            .map(
              (branch) => branch
                  .map((e) => <String, Vector3>{e.keys.first: e.values.first})
                  .toList(),
            )
            .toList(),
        simulatedBeamList.map((e) => e.copy()).toList(),
      );
}
