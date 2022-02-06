import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/view_model_change_notifier.dart';
import '../optics_diagram/optics.dart';
import '../simulation/optics_state.dart';
import '../simulation/simulation_repository.dart';
import '../utils/random_string.dart';

final createOpticsDialogViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => CreateOpticsDialogViewModel(
    ref.watch(simulationRepositoryProvider),
    ref.watch(opticsStateActionProvider),
  ),
);

class CreateOpticsDialogViewModel extends ViewModelChangeNotifier {
  CreateOpticsDialogViewModel(
    this._simulationRepository,
    this._opticsStateAction,
  );
  final SimulationRepository _simulationRepository;
  final OpticsStateAction _opticsStateAction;

  Optics newOptics = Mirror(
    randomString(4),
    'New Optics',
    OpticsPosition(
      x: 0,
      y: 0,
      z: 0,
      theta: 0,
      phi: 0,
    ),
  );

  List<Optics> get currentOpticsList => _simulationRepository.currentOpticsList;

  void addOptics() {
    if (currentOpticsList.isEmpty) {
      _opticsStateAction.addFirstNode(newOptics);
    }
    _opticsStateAction.addOptics(newOptics);
    notifyListeners();
  }

  void changeOpticsType(String? newValue) {
    switch (newValue) {
      case 'Mirror':
        newOptics = Mirror(newOptics.id, newOptics.name, newOptics.position);
        break;
      case 'PBS':
        newOptics = PolarizingBeamSplitter(
            newOptics.id, newOptics.name, newOptics.position);
        break;
      default:
        return;
    }
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
