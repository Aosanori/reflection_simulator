/*
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
  static const margin = 0.01;

  Map<double, SimulationResult> runSimulation({
    required Optics target,
    required String targetValue,
  }) {
    final results = <double, SimulationResult>{};

    for (var value = -1.0; value <= 1.0; value += margin) {
      final tmpTarget = target.copy();
      final tmpOpticsTree = _opticsStateSource.currentOpticsTree.copy();
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

      final nodeIDs =
          _opticsStateSource.opticsListVersusOpticsNode[tmpTarget.id]!;
      // 枝から取得しているためkeyを変えても意味ない
      for (final edges in tmpOpticsTree.nodes.values) {
        for (final edge in edges) {
          if (nodeIDs.contains(edge.id)) {
            edge.data = tmpTarget;
          }
        }
      }

      final result = _simulationService.runSimulation(
        currentBeam: _opticsStateSource.currentBeam,
        currentOpticsTree: tmpOpticsTree,
      );
      results[currentValue] = result;
    }
    return results;
  }
}*/
