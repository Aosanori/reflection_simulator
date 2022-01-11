import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart';

import '../common/view_model_change_notifier.dart';
import '../optics_diagram/optics.dart';
import '../simulation/simulation_service.dart';

final beamReflectionPositionListDisplayViewModelProvider =
    ChangeNotifierProvider.autoDispose(
  (ref) => BeamReflectionPositionListDisplayViewModel(
    ref.watch(simulationServiceProvider),
  ),
);

class BeamReflectionPositionListDisplayViewModel
    extends ViewModelChangeNotifier {
  BeamReflectionPositionListDisplayViewModel(this._simulationService);
  final SimulationService _simulationService;
  List<Vector3> get simulationResult =>
      _simulationService.simulatedReflectPositions;
  List<Optics> get currentOpticsList => _simulationService.currentOpticsList;
}
