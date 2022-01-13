import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../common/view_model_change_notifier.dart';
import '../../simulation/simulation_service.dart';

import '../beam.dart';

final beamPositionViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => BeamPositionViewModel(ref.watch(simulationServiceProvider)),
);

class BeamPositionViewModel extends ViewModelChangeNotifier {
  BeamPositionViewModel(this._simulationService) {
    currentBeam = _simulationService.currentBeam;
  }

  final SimulationService _simulationService;

  late Beam currentBeam;

  void runSimulation() => _simulationService.runSimulation();

  void changeBeamType(String newValue) {
    _simulationService.currentBeam.type = newValue;
    notifyListeners();
    _simulationService.runSimulation();
  }

  void changeValueOfX(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      currentBeam.startFrom.x = value;
      notifyListeners();
    }
  }

  void changeValueOfY(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      currentBeam.startFrom.y = value;
      notifyListeners();
    }
  }

  void changeValueOfZ(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      currentBeam.startFrom.z = value;
      notifyListeners();
    }
  }

  void changeValueOfTheta(double newValue) {
    currentBeam.startFrom.theta = newValue;
    notifyListeners();
    _simulationService.runSimulation();
  }

  void changeValueOfPhi(double newValue) {
    currentBeam.startFrom.phi = newValue;
    notifyListeners();
    _simulationService.runSimulation();
  }

  void changeValueOfWaveLength(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      currentBeam.waveLength = value;
      notifyListeners();
    }
  }

  void changeValueOfBeamWaist(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      currentBeam.beamWaist = value;
      notifyListeners();
    }
  }
}
