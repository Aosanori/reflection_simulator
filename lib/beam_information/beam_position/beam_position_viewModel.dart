import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/view_model_change_notifier.dart';
import '../../simulation/optics_state.dart';
import '../../simulation/simulation_repository.dart';
import '../../utils/environments_variables.dart';
import '../beam.dart';

final beamPositionViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => BeamPositionViewModel(
    ref.watch(simulationRepositoryProvider),
    ref.watch(opticsStateActionProvider),
  ),
);

class BeamPositionViewModel extends ViewModelChangeNotifier {
  BeamPositionViewModel(this._simulationRepository, this._opticsStateAction) {
    currentBeam = _simulationRepository.currentBeam;
    if (_simulationRepository.currentOpticsList.isNotEmpty &&
        _simulationRepository.currentOpticsTree.nodes.isNotEmpty) {
      final nextOptics = _simulationRepository.currentOpticsList.first;
      final directionVector =
          nextOptics.position.vector - currentBeam.startFrom.vector;
      final directionToNextOptics =
          atan(directionVector.y / directionVector.x) * 180 / pi;
      rangeOfTheta = [
        directionToNextOptics - adjustableAngleOfBeam,
        directionToNextOptics + adjustableAngleOfBeam
      ];
      currentBeam.startFrom.theta = directionToNextOptics;
    } else {
      rangeOfTheta = [-180, 180];
    }
  }

  final SimulationRepository _simulationRepository;
  final OpticsStateAction _opticsStateAction;

  late Beam currentBeam;
  late List<double>? rangeOfTheta;
  late Beam newBeam = currentBeam.copy();

  void changeBeam() {
    _opticsStateAction.editBeam(newBeam);
    notifyListeners();
  }

  void changeBeamType(String newValue) {
    newBeam.type = newValue;
    notifyListeners();
  }

  void changeValueOfX(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      newBeam.startFrom.x = value;
      notifyListeners();
    }
  }

  void changeValueOfY(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      newBeam.startFrom.y = value;

      notifyListeners();
    }
  }

  void changeValueOfZ(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      newBeam.startFrom.z = value;

      notifyListeners();
    }
  }

  void changeValueOfTheta(double newValue) {
    newBeam.startFrom.theta = newValue;
    changeBeam();
    notifyListeners();
  }

  void changeValueOfPhi(double newValue) {
    newBeam.startFrom.phi = newValue;
    changeBeam();
    notifyListeners();
  }

  void changeValueOfWaveLength(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      newBeam.waveLength = value;
      notifyListeners();
    }
  }

  void changeValueOfBeamWaist(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      newBeam.beamWaist = value;
      notifyListeners();
    }
  }
}
