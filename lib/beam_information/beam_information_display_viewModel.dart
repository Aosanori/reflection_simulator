import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/view_model_change_notifier.dart';
import '../utils/environments_variables.dart';
import 'beam.dart';

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

    print(currentBeam.vector);
    print(opticsList[0].normalVector);
    print(currentBeam.reflect(opticsList[0]));
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
