import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart' as vm;

import '../common/view_model_change_notifier.dart';
import '../optics_diagram/optics.dart';
import '../simulation/simulation_service.dart';
import '../utils/graph.dart';

final opticsDisplayViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => OpticsDisplayViewModel(ref.watch(simulationServiceProvider)),
);

class OpticsDisplayViewModel extends ViewModelChangeNotifier {
  OpticsDisplayViewModel(this._simulationService);

  final SimulationService _simulationService;

  Graph<Optics> get currentOpticsTree => _simulationService.currentOpticsTree;
  List<Optics> get currentOpticsList => _simulationService.currentOpticsList;
  List<List<Map<int,vm.Vector3>>> get simulationResult => _simulationService.refPos;

  void returnToZero(TransformationController transformationController) {
    transformationController.value = Matrix4.identity();
  }
}
