import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/view_model_change_notifier.dart';
import '../../simulation/simulation_service.dart';
import '../optics_diagram/optics.dart';
import '../utils/random_string.dart';

final createOpticsDialogViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => CreateOpticsDialogViewModel(ref.watch(simulationServiceProvider)),
);

class CreateOpticsDialogViewModel extends ViewModelChangeNotifier {
  CreateOpticsDialogViewModel(this._simulationService);
  final SimulationService _simulationService;

  Optics newOptics = Optics(
    randomString(4),
    'New Optics',
    OpticsPosition(
      x: 0,
      y: 0,
      z: 0,
      theta: 0,
      phi: 0,
    ),
    'Mirror',
  );

  void addToDiagram() {
    _simulationService.currentOpticsList.add(newOptics);
    _simulationService.runSimulation();
  }

  void changeOpticsType(String? newValue) {
    newOptics.type = newValue!;
    notifyListeners();
  }

  void changeValueOfName(String newValue) {
    newOptics.name = newValue;
    notifyListeners();
  }

  void changeValueOfX(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      newOptics.position.x = value;
      notifyListeners();
    }
  }

  void changeValueOfY(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      newOptics.position.y = value;
      notifyListeners();
    }
  }

  void changeValueOfZ(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      newOptics.position.z = value;
      notifyListeners();
    }
  }

  void changeValueOfTheta(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      newOptics.position.theta = value;
      notifyListeners();
    }
  }

  void changeValueOfPhi(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      newOptics.position.phi = value;
      notifyListeners();
    }
  }

  void changeValueOfSize(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      newOptics.size = value;
      notifyListeners();
    }
  }
}
