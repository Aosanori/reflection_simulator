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
    if (_simulationRepository.currentOpticsList.isNotEmpty) {
      final nextOptics = _simulationRepository.currentOpticsList.first;
      final directionToNextOptics = currentBeam.startFrom.vector.angleTo(
                nextOptics.position.vector - currentBeam.startFrom.vector,
              ) *
              180 /
              pi -
          90;
      rangeOfTheta = [
        directionToNextOptics - adjustableAngleOfBeam,
        directionToNextOptics + adjustableAngleOfBeam
      ];
    }
  }

  final SimulationRepository _simulationRepository;
  final OpticsStateAction _opticsStateAction;

  late Beam currentBeam;
  late List<double>? rangeOfTheta;

  void changeBeamType(String newValue) {
    final newBeam = currentBeam.copy()..type = newValue;
    _opticsStateAction.editBeam(newBeam);
    notifyListeners();
  }

  void changeValueOfX(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      final newBeam = currentBeam.copy()..startFrom.x = value;
      _opticsStateAction.editBeam(newBeam);
      notifyListeners();
    }
  }

  void changeValueOfY(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      final newBeam = currentBeam.copy()..startFrom.y = value;
      _opticsStateAction.editBeam(newBeam);
      notifyListeners();
    }
  }

  void changeValueOfZ(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      final newBeam = currentBeam.copy()..startFrom.z = value;
      _opticsStateAction.editBeam(newBeam);
      notifyListeners();
    }
  }

  void changeValueOfTheta(double newValue) {
    final newBeam = currentBeam.copy()..startFrom.theta = newValue;
    _opticsStateAction.editBeam(newBeam);
    notifyListeners();
  }

  void changeValueOfPhi(double newValue) {
    final newBeam = currentBeam.copy()..startFrom.phi = newValue;
    _opticsStateAction.editBeam(newBeam);
    notifyListeners();
  }

  void changeValueOfWaveLength(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      final newBeam = currentBeam.copy()..waveLength = value;
      _opticsStateAction.editBeam(newBeam);
      notifyListeners();
    }
  }

  void changeValueOfBeamWaist(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      final newBeam = currentBeam.copy()..beamWaist = value;
      _opticsStateAction.editBeam(newBeam);
      notifyListeners();
    }
  }
}
