import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reflection_simulator/simulation/simulation_repository.dart';

import '../common/view_model_change_notifier.dart';
import '../simulation/simulation_state.dart';
import 'beam.dart';

final beamInformationDisplayViewModelProvider =
    ChangeNotifierProvider.autoDispose(
  (ref) =>
      BeamInformationDisplayViewModel(ref.watch(simulationRepositoryProvider)),
);

class BeamInformationDisplayViewModel extends ViewModelChangeNotifier {
  BeamInformationDisplayViewModel(this._simulationRepository);

  final SimulationRepository _simulationRepository;

  Beam get currentBeam => _simulationRepository.currentBeam;
  /*
  void changeBeamWaist(String newValue) {
    _simulationStateStore.state.currentBeam.beamWaist = double.parse(newValue);
    notifyListeners();
    _simulationStateStore.runSimulation();
  }

  void changeWaveLength(String newValue) {
    _simulationStateStore.state.currentBeam.waveLength = double.parse(newValue);
    notifyListeners();
    _simulationStateStore.runSimulation();
  }*/
}
