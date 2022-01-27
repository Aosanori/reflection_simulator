import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/view_model_change_notifier.dart';
import '../optics_diagram/optics.dart';
import '../simulation/optics_state.dart';
import '../simulation/simulation_repository.dart';

final editOpticsDialogViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<EditOpticsDialogViewModel, int>(
  (ref, index) => EditOpticsDialogViewModel(
    ref.watch(simulationRepositoryProvider),
    ref.watch(opticsStateActionProvider),
    index,
  ),
);

class EditOpticsDialogViewModel extends ViewModelChangeNotifier {
  EditOpticsDialogViewModel(
      this._simulationRepository, this._opticsStateAction, this.index) {
    editOptics = _simulationRepository.currentOpticsList[index].copy();
  }
  final SimulationRepository _simulationRepository;
  final OpticsStateAction _opticsStateAction;
  final int index;

  late Optics editOptics;

  void addToDiagram() {
    _opticsStateAction.editOptics(editOptics);
    notifyListeners();
  }

  void changeOpticsType(String? newValue) {
    switch (newValue) {
      case 'Mirror':
        editOptics = Mirror(
          editOptics.id,
          editOptics.name,
          editOptics.position,
        );
        break;
      case 'PBS':
        editOptics = PolarizingBeamSplitter(
          editOptics.id,
          editOptics.name,
          editOptics.position,
        );
        break;
      default:
        return;
    }
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
