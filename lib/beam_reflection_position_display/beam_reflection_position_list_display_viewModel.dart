import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart';

import '../common/view_model_change_notifier.dart';
import '../optics_diagram/optics.dart';
import '../simulation/simulation_state_store_service.dart';

final beamReflectionPositionListDisplayViewModelProvider =
    ChangeNotifierProvider.autoDispose(
  (ref) => BeamReflectionPositionListDisplayViewModel(
    ref.watch(simulationStateStoreProvider),
  ),
);

class BeamReflectionPositionListDisplayViewModel
    extends ViewModelChangeNotifier {
  BeamReflectionPositionListDisplayViewModel(this._simulationStateStore);
  final SimulationStateStore _simulationStateStore;

  Map<Optics, List<Vector3>> get simulationResult =>
      _simulationStateStore.state.reflectPositionsDistributedByOptics;
}
