import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart' as vm;

import '../common/view_model_change_notifier.dart';
import '../optics_diagram/optics.dart';
import '../simulation/simulation_repository.dart';
import '../utils/graph.dart';

final opticsDisplayViewModelProvider = ChangeNotifierProvider(
  (ref) => OpticsDisplayViewModel(ref.watch(simulationRepositoryProvider)),
);

class OpticsDisplayViewModel extends ViewModelChangeNotifier {
  OpticsDisplayViewModel(this._simulationRepository);

  final SimulationRepository _simulationRepository;

  Graph<Optics> get currentOpticsTree => _simulationRepository.currentOpticsTree;
  List<Optics> get currentOpticsList => _simulationRepository.currentOpticsList;
  List<List<Map<int,vm.Vector3>>> get simulationResult => _simulationRepository.simulationResult.reflectionPositions;

  void returnToZero(TransformationController transformationController) {
    transformationController.value = Matrix4.identity();
  }
}
