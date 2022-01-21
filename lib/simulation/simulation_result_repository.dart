import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart';

import '../optics_diagram/optics.dart';
import '../utils/graph.dart';
import 'simulation_service.dart';

final simulationResultRepositoryProvider = Provider.autoDispose(
  (ref) => SimulationResultRepository(
    ref.watch(simulationServiceProvider),
  ),
);

class SimulationResultRepository {
  SimulationResultRepository(this._simulationService);
  final SimulationService _simulationService;

  List<Optics> get currentOpticsList => _simulationService.currentOpticsList;
  Graph<Optics> get currentOpticsTree => _simulationService.currentOpticsTree;
  List<List<Map<int, Vector3>>> get reflectPositions =>
      _simulationService.refPos;

  void runSimulation() => _simulationService.runSim();

  Optics getOpticsByNodeId(int nodeID) =>
      currentOpticsTree.nodes.keys.elementAt(nodeID).data;

  List<Vector3> getResultByOptics(Optics optics) =>
      reflectPositionsDistributedByOptics[optics]!;

  Map<Optics, List<Vector3>> get reflectPositionsDistributedByOptics {
    final result = <Optics, List<Vector3>>{};
    for (final optics in currentOpticsList) {
      result[optics] = <Vector3>[];
    }
    for (final oneBranchResult in reflectPositions) {
      for (final position in oneBranchResult) {
        final nodeID = position.keys.first;
        if (nodeID >= 0) {
          final optics = currentOpticsTree.nodes.keys.elementAt(nodeID).data;
          result[optics]!.add(position.values.first);
        }
      }
    }
    return result;
  }
}
