import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart';

import '../common/view_model_change_notifier.dart';
import '../optics_diagram/optics.dart';
import '../simulation/simulation_service.dart';

final opticsDisplayViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => OpticsDisplayViewModel(ref.watch(simulationServiceProvider)),
);

class OpticsDisplayViewModel extends ViewModelChangeNotifier {
  OpticsDisplayViewModel(this._simulationService);

  final SimulationService _simulationService;

  List<Optics> get currentOpticsList => _simulationService.currentOpticsList;
  List<Vector3> get simulationResult =>
      _simulationService.simulatedReflectPositions;
}