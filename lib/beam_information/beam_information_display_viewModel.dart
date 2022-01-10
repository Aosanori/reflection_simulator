import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reflection_simulator/utils/environments_variables.dart';

import '../common/view_model_change_notifier.dart';
import 'beam.dart';

final beamInformationDisplayViewModelProvider =
    ChangeNotifierProvider.autoDispose(
  (ref) => BeamInformationDisplayViewModel(),
);

class BeamInformationDisplayViewModel extends ViewModelChangeNotifier {
  BeamInformationDisplayViewModel() {
    currentBeam = example_beam;
  }

  late Beam currentBeam;

  void changeBeamType(String newValue) {
    currentBeam.type = newValue;
    notifyListeners();
  }

  void changeBeamWaist() {
    notifyListeners();
  }

  void changeWaveLength() {
    notifyListeners();
  }
}
