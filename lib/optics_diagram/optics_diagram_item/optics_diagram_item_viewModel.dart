import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../common/view_model_change_notifier.dart';
import '../../simulation/simulation_service.dart';

import '../optics.dart';

final opticsDiagramItemViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<OpticsDiagramItemViewModel, int>(
  (ref, index) =>
      OpticsDiagramItemViewModel(ref.watch(simulationServiceProvider), index),
);

class OpticsDiagramItemViewModel extends ViewModelChangeNotifier {
  OpticsDiagramItemViewModel(this._simulationService, this.index) {
    _optics = _simulationService.currentOpticsList[index];
  }
  final int index;
  final SimulationService _simulationService;

  late Optics _optics;

  Optics get optics => _optics;

  void changeTheta(int index, double value) {
    _optics.position.theta = value;
    notifyListeners();
    _simulationService.runSimulation();
  }

  void changePhi(int index, double value) {
    _optics.position.phi = value;
    notifyListeners();
    _simulationService.runSimulation();
  }
}
