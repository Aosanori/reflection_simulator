import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart';

import '../beam_information/beam.dart';
import '../common/view_model_change_notifier.dart';
import '../optics_diagram/optics.dart';
import '../utils/graph.dart';
import 'optics_state.dart';
import 'simulation_service.dart';

// TODO: isCombined: 別れたビームの終端が同じ場合

class SimulationState {
  SimulationState({
    required this.currentBeam,
    required this.currentOpticsTree,
    required this.currentOpticsList,
    required this.simulationResult,
  });

  SimulationState copy() => SimulationState(
        currentBeam: currentBeam,
        currentOpticsTree: currentOpticsTree,
        currentOpticsList: currentOpticsList,
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
        if (nodeID >= 0) {
          final optics = currentOpticsTree.nodes.keys.elementAt(nodeID).data;
          result[optics]!.add(position.values.first);
        }
      }
    }
    return result;
  }
}

final simulationStateStoreProvider = ChangeNotifierProvider(
  (ref) => SimulationStateStore(
    ref.watch(simulationServiceProvider),
    ref.watch(opticsStateProvider),
  ),
);

class SimulationStateStore extends ViewModelChangeNotifier {
  SimulationStateStore(this._simulationService, this._opticsStateSource) {
    state = SimulationState(
      currentBeam: _opticsStateSource.currentBeam,
      currentOpticsTree: _opticsStateSource.currentOpticsTree,
      currentOpticsList: _opticsStateSource.currentOpticsList,
      simulationResult: _simulationService.runSimulation(
        currentBeam: _opticsStateSource.currentBeam,
        currentOpticsTree: _opticsStateSource.currentOpticsTree,
        currentOpticsList: _opticsStateSource.currentOpticsList,
      ),
    );
  }

  final SimulationService _simulationService;
  final OpticsState _opticsStateSource;
  late SimulationState state;

  void runSimulation({
    required Beam currentBeam,
    required Graph<Optics> currentOpticsTree,
    required List<Optics> currentOpticsList,
  }) {
    state = SimulationState(
      currentBeam: _opticsStateSource.currentBeam,
      currentOpticsTree: _opticsStateSource.currentOpticsTree,
      currentOpticsList: _opticsStateSource.currentOpticsList,
      simulationResult: _simulationService.runSimulation(
        currentBeam: _opticsStateSource.currentBeam,
        currentOpticsTree: _opticsStateSource.currentOpticsTree,
        currentOpticsList: _opticsStateSource.currentOpticsList,
      ),
    );
    notifyListeners();
  }
}
