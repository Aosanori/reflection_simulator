import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/view_model_change_notifier.dart';
import '../simulation/simulation_repository.dart';
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

  void changeBeamWaist(String newValue) {
    _simulationRepository.currentBeam.copy().beamWaist = double.parse(newValue);

    notifyListeners();
  }

  void changeWaveLength(String newValue) {
    _simulationRepository.currentBeam.copy().waveLength =
        double.parse(newValue);

    notifyListeners();
  }
}
