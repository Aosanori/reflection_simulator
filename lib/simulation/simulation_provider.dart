import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart';

import '../beam_information/beam.dart';
import '../common/view_model_change_notifier.dart';
import '../optics_diagram/optics.dart';
import '../utils/environments_variables.dart';

final simulationServiceProvider = ChangeNotifierProvider.autoDispose(
  (ref) => SimulationService(),
);

class SimulationService extends ViewModelChangeNotifier {
  SimulationService() {
    currentOpticsList = opticsList;
    currentBeam = example_beam;
    simulatedReflectPositions = runSimulation();
  }

  late List<Optics> currentOpticsList;
  late Beam currentBeam;
  late List<Vector3?> simulatedReflectPositions;

  List<Vector3?> runSimulation() {
    // インスタンスをコピー
    final simulationBeam = Beam(
      type: currentBeam.type,
      waveLength: currentBeam.waveLength,
      beamWaist: currentBeam.beamWaist,
      startFrom: currentBeam.startFrom,
    );
    final reflectPositions =
        List<Vector3?>.generate(currentOpticsList.length, (index) => null);
    const cutted = false;

    for (var i = 0; i < currentOpticsList.length; i++) {
      reflectPositions[i] = simulationBeam.reflect(currentOpticsList[i]);
      //beam.startFrom = ;
    }
    notifyListeners();
    return reflectPositions;
  }
}
