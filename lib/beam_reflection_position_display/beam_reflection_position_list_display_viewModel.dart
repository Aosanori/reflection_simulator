import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart';

import '../common/view_model_change_notifier.dart';
import '../optics_diagram/optics.dart';
import '../simulation/simulation_result_repository.dart';

final beamReflectionPositionListDisplayViewModelProvider =
    ChangeNotifierProvider.autoDispose(
  (ref) => BeamReflectionPositionListDisplayViewModel(
    ref.watch(simulationResultRepositoryProvider),
  ),
);

class BeamReflectionPositionListDisplayViewModel
    extends ViewModelChangeNotifier {
  BeamReflectionPositionListDisplayViewModel(this._simulationResultRepository);
  final SimulationResultRepository _simulationResultRepository;

  Map<Optics, List<Vector3>> get simulationResult =>
      _simulationResultRepository.reflectPositionsDistributedByOptics;
}
