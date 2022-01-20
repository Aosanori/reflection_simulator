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
    currentOpticsList = initialOpticsList;
    currentBeam = initialBeam;
    simulatedReflectPositions = runSimulation();
  }

  late List<Optics> currentOpticsList;
  late Beam currentBeam;
  late List<Vector3> simulatedReflectPositions;
  


  List<Vector3> runSimulation() {
    // インスタンスをコピー
    final simulationBeam = Beam(
      type: currentBeam.type,
      waveLength: currentBeam.waveLength,
      beamWaist: currentBeam.beamWaist,
      startFrom: currentBeam.startFrom,
    );
    final reflectPositions = <Vector3>[currentBeam.startFrom.vector];

    for (var i = 0; i < currentOpticsList.length; i++) {
      reflectPositions.add(simulationBeam.reflect(currentOpticsList[i]));
    }
    simulatedReflectPositions = reflectPositions;
    notifyListeners();
    return reflectPositions;
  }
}
