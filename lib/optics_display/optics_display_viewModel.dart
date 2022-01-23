import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart' as vm;

import '../common/view_model_change_notifier.dart';
import '../optics_diagram/optics.dart';
import '../simulation/simulation_state_store_service.dart';
import '../utils/graph.dart';

final opticsDisplayViewModelProvider = ChangeNotifierProvider(
  (ref) => OpticsDisplayViewModel(ref.watch(simulationStateStoreProvider)),
);

class OpticsDisplayViewModel extends ViewModelChangeNotifier {
  OpticsDisplayViewModel(this._simulationStateStore);

  final SimulationStateStore _simulationStateStore;

  Graph<Optics> get currentOpticsTree => _simulationStateStore.state.currentOpticsTree;
  List<Optics> get currentOpticsList => _simulationStateStore.state.currentOpticsList;
  List<List<Map<int,vm.Vector3>>> get simulationResult => _simulationStateStore.state.simulationResult.reflectionPositions;

  void returnToZero(TransformationController transformationController) {
    transformationController.value = Matrix4.identity();
  }
}
