import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reflection_simulator/optics_diagram/optics.dart';
import 'package:vector_math/vector_math.dart';

import '../common/view_model_change_notifier.dart';
import '../utils/environments_variables.dart';
import 'beam.dart';

List<Vector3?> simulation(Beam beam, List<Optics> opticsList) {
  var reflectPositions =
      List<Vector3?>.generate(opticsList.length, (index) => null);
  bool cutted = false;

  for (var i = 0; i < opticsList.length; i++) {
    reflectPositions[i] = beam.reflect(opticsList[i]);
    //beam.startFrom = ;
  }

  return reflectPositions;
}

final beamInformationDisplayViewModelProvider =
    ChangeNotifierProvider.autoDispose(
  (ref) => BeamInformationDisplayViewModel(),
);

class BeamInformationDisplayViewModel extends ViewModelChangeNotifier {
  BeamInformationDisplayViewModel() {
    currentBeam = example_beam;
    beamWaistInputController =
        TextEditingController(text: currentBeam.beamWaist.toString());
    beamWaveLengthInputController =
        TextEditingController(text: currentBeam.waveLength.toString());

    simulation(currentBeam, opticsList);
  }

  late Beam currentBeam;
  late TextEditingController beamWaveLengthInputController;
  late TextEditingController beamWaistInputController;

  void changeBeamType(String newValue) {
    currentBeam.type = newValue;
    notifyListeners();
  }

  void changeBeamWaist(String newValue) {
    currentBeam.beamWaist = double.parse(newValue);
    notifyListeners();
  }

  void changeWaveLength(String newValue) {
    currentBeam.waveLength = double.parse(newValue);
    notifyListeners();
  }
}
