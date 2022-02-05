import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../beam_information/beam.dart';
import '../optics_diagram/optics.dart';
import '../utils/graph.dart';
import 'optics_state.dart';
import 'simulation_result.dart';
import 'simulation_service.dart';
import 'simulation_state.dart';

class VariableOfSimulationWithChangingValue {
  const VariableOfSimulationWithChangingValue(
    this.target,
    this.targetValue, {
    this.margin = 0.005,
  });
  final Optics target;
  final String targetValue;
  final double margin;
}

final simulationRepositoryProvider = Provider(
  (ref) => SimulationRepository(
    ref.watch(opticsStateProvider),
    ref.watch(simulationServiceProvider),
  ),
);

class SimulationRepository {
  SimulationRepository(this._opticsStateSource, this._simulationService);

  final SimulationService _simulationService;
  final OpticsState _opticsStateSource;

  Graph<Optics> get currentOpticsTree => _opticsStateSource.currentOpticsTree;

  List<Optics> get currentOpticsList =>
      _opticsStateSource.currentOpticsList.map((optics) => optics).toList();

  Beam get currentBeam => _opticsStateSource.currentBeam;

  SimulationState get simulationState => SimulationState(
        currentBeam: currentBeam,
        currentOpticsTree: currentOpticsTree,
        currentOpticsList: currentOpticsList,
        simulationResult: simulationResult,
      );

  SimulationResult get simulationResult => _simulationService.runSimulation(
        currentBeam: currentBeam,
        currentOpticsTree: currentOpticsTree,
      );

  Map<double, SimulationResult> runSimulationWithChangingValue(
    VariableOfSimulationWithChangingValue variable,
  ) {
    final results = <double, SimulationResult>{};

    for (var value = -0.3; value <= 0; value += variable.margin) {
      final tmpTarget = variable.target.copy();
      final tmpOpticsTree = _opticsStateSource.currentOpticsTree.copy();
      var currentValue = 0.0;
      switch (variable.targetValue) {
        case 'x':
          tmpTarget.position.x += value;
          currentValue = tmpTarget.position.x;
          break;
        case 'y':
          tmpTarget.position.y += value;
          currentValue = tmpTarget.position.y;
          break;
        case 'z':
          tmpTarget.position.z += value;
          currentValue = tmpTarget.position.z;
          break;
        case 'theta':
          tmpTarget.position.theta += value;
          currentValue = tmpTarget.position.theta;
          break;
        case 'phi':
          tmpTarget.position.phi += value;
          currentValue = tmpTarget.position.phi;
          break;
        case 'x-y Diagonal':
          tmpTarget.position.x += value;
          tmpTarget.position.y += value;
          currentValue = value;
          break;
        default:
          break;
      }

      final nodeIDs =
          _opticsStateSource.opticsListVersusOpticsNode[tmpTarget.id]!;
      // 枝から取得しているためkeyを変えても意味ない
      for (final edges in tmpOpticsTree.nodes.values) {
        for (final edge in edges) {
          if (edge != null && nodeIDs.contains(edge.id)) {
            edge.data = tmpTarget;
          }
        }
      }

      final result = _simulationService.runSimulation(
        currentBeam: currentBeam,
        currentOpticsTree: tmpOpticsTree,
      );
      results[currentValue] = result;
    }
    return results;
  }
}
