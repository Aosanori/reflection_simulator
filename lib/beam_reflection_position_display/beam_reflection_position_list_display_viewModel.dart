import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart';

import '../beam_information/beam.dart';
import '../common/view_model_change_notifier.dart';
import '../optics_diagram/optics.dart';
import '../simulation/simulation_repository.dart';

final beamReflectionPositionListDisplayViewModelProvider =
    ChangeNotifierProvider.autoDispose(
  (ref) => BeamReflectionPositionListDisplayViewModel(
    ref.watch(simulationRepositoryProvider),
  ),
);

class BeamReflectionPositionListDisplayViewModel
    extends ViewModelChangeNotifier {
  BeamReflectionPositionListDisplayViewModel(this._simulationRepository);
  final SimulationRepository _simulationRepository;

  Map<Optics, Map<int,Vector3>> get simulationResult =>
      _simulationRepository.simulationState.reflectPositionsDistributedByOptics;

  List<Beam> get simulatedBeamList =>
      _simulationRepository.simulationState.simulationResult.simulatedBeamList;
}
