import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../optics_diagram/optics.dart';
import 'optics_state.dart';
import 'simulation_service.dart';

final simulationWithChangingValueProvider = Provider(
  (ref) => SimulationWithChangingValue(
    ref.watch(simulationServiceProvider),
    ref.watch(opticsStateProvider),
  ),
);

class SimulationWithChangingValue {
  SimulationWithChangingValue(
    this._simulationService,
    this._opticsStateSource,
  );

  final SimulationService _simulationService;
  final OpticsState _opticsStateSource;
  static const margin = 0.05;

  Map<double, SimulationResult> runSimulation({
    required Optics target,
    required String targetValue,
  }) {
    final results = <double, SimulationResult>{};

    for (var value = -1.0; value <= 1.0; value += margin) {
      final tmpTarget = target.copy();
      var currentValue = 0.0;
      switch (targetValue) {
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
        default:
          break;
      }

      final tmpOpticsTree = _opticsStateSource.currentOpticsTree.copy();

      for (final nodeId
          in _opticsStateSource.opticsListVersusOpticsNode[tmpTarget.id]!) {
        tmpOpticsTree.nodes.keys.elementAt(nodeId).data = tmpTarget;
      }
      final result = _simulationService.runSimulation(
        currentBeam: _opticsStateSource.currentBeam,
        currentOpticsTree: tmpOpticsTree,
      );
      results[currentValue] = result;
    }
    return results;
  }
}
