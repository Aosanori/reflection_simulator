import 'package:vector_math/vector_math.dart';

import '../beam_information/beam.dart';
import '../optics_diagram/optics.dart';
import '../utils/graph.dart';
import 'simulation_result.dart';

class SimulationState {
  SimulationState({
    required this.currentBeam,
    required this.currentOpticsTree,
    required this.currentOpticsList,
    required this.simulationResult,
  });

  SimulationState copy() => SimulationState(
        currentBeam: currentBeam.copy(),
        currentOpticsTree: currentOpticsTree.copy(),
        currentOpticsList: currentOpticsList.map((e) => e.copy()).toList(),
        simulationResult: simulationResult,
      );

  final Beam currentBeam;
  final Graph<Optics> currentOpticsTree;
  final List<Optics> currentOpticsList;
  final SimulationResult simulationResult;

  Map<Optics, List<Vector3>> get reflectPositionsDistributedByOptics {
    final result = <Optics, List<Vector3>>{};
    final reflectionPositions = simulationResult.reflectionPositions;
    for (final optics in currentOpticsList) {
      result[optics] = <Vector3>[];
    }
    for (final oneBranchResult in reflectionPositions) {
      for (final position in oneBranchResult) {
        final nodeID = position.keys.first;
        if (nodeID != '-1') {
          final optics = currentOpticsTree.opticsWithNodeID[nodeID]!;
          if (result[optics] == null) {
            result[optics] = <Vector3>[];
          }
          result[optics]!.add(position.values.first);
        }
      }
    }
    return result;
  }
}
