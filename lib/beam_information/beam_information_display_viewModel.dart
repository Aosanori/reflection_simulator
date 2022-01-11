import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/view_model_change_notifier.dart';
import '../simulation/simulation_provider.dart';
import 'beam.dart';

final beamInformationDisplayViewModelProvider =
    ChangeNotifierProvider.autoDispose(
  (ref) =>
      BeamInformationDisplayViewModel(ref.watch(simulationServiceProvider)),
);

class BeamInformationDisplayViewModel extends ViewModelChangeNotifier {
  BeamInformationDisplayViewModel(this._simulationService) {
    beamWaistInputController = TextEditingController(
        text: _simulationService.currentBeam.beamWaist.toString());
    beamWaveLengthInputController = TextEditingController(
        text: _simulationService.currentBeam.waveLength.toString());
  }

  final SimulationService _simulationService;
  late TextEditingController beamWaveLengthInputController;
  late TextEditingController beamWaistInputController;

  Beam get currentBeam => _simulationService.currentBeam;

  void changeBeamType(String newValue) {
    _simulationService.currentBeam.type = newValue;
    notifyListeners();
    _simulationService.runSimulation();
  }

  void changeBeamWaist(String newValue) {
    _simulationService.currentBeam.beamWaist = double.parse(newValue);
    notifyListeners();
    _simulationService.runSimulation();
  }

  void changeWaveLength(String newValue) {
    _simulationService.currentBeam.waveLength = double.parse(newValue);
    notifyListeners();
    _simulationService.runSimulation();
  }
}
