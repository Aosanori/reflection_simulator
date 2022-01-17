import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/view_model_change_notifier.dart';
import '../../simulation/simulation_service.dart';
import '../optics_diagram/optics.dart';

final editOpticsDialogViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<EditOpticsDialogViewModel, int>(
  (ref, index) =>
      EditOpticsDialogViewModel(ref.watch(simulationServiceProvider), index),
);

class EditOpticsDialogViewModel extends ViewModelChangeNotifier {
  EditOpticsDialogViewModel(this._simulationService, this.index) {
    editOptics = _simulationService.currentOpticsList[index];
  }
  final SimulationService _simulationService;
  final int index;

  late Optics editOptics;

  void addToDiagram() {
    _simulationService.currentOpticsList[index] = editOptics;
    _simulationService.runSimulation();
  }

  void changeOpticsType(String? newValue) {
    editOptics.type = newValue!;
    notifyListeners();
  }

  void changeValueOfName(String newValue) {
    editOptics.name = newValue;
    notifyListeners();
  }

  void changeValueOfX(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      editOptics.position.x = value;
      notifyListeners();
    }
  }

  void changeValueOfY(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      editOptics.position.y = value;
      notifyListeners();
    }
  }

  void changeValueOfZ(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      editOptics.position.z = value;
      notifyListeners();
    }
  }

  void changeValueOfTheta(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      editOptics.position.theta = value;
      notifyListeners();
    }
  }

  void changeValueOfPhi(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      editOptics.position.phi = value;
      notifyListeners();
    }
  }

  void changeValueOfSize(String newValue) {
    final value = double.tryParse(newValue);
    if (value != null) {
      editOptics.size = value;
      notifyListeners();
    }
  }
}
