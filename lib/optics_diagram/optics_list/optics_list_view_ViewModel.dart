import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/view_model_change_notifier.dart';
import '../../simulation/optics_state.dart';
import '../../simulation/simulation_repository.dart';
import '../optics.dart';

final opticsListViewViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => OpticsListViewViewModel(
    ref.watch(simulationRepositoryProvider),
    ref.watch(opticsStateActionProvider),
  ),
);

class OpticsListViewViewModel extends ViewModelChangeNotifier {
  OpticsListViewViewModel(this._simulationRepository, this._opticsStateAction);
  final SimulationRepository _simulationRepository;
  final OpticsStateAction _opticsStateAction;
  List<Optics> get currentOpticsList => _simulationRepository.currentOpticsList;

  void dragAndDrop(int oldIndex, int newIndex) {
    /*if (newIndex > oldIndex) {
      // 元々下にあった要素が上にずれるため一つ分後退させる
      // ignore: parameter_assignments
      newIndex -= 1;
    }

    // 並び替え処理
    final optics = _simulationRepository.state.currentOpticsList[oldIndex];
    _simulationRepository.state.currentOpticsList
      ..removeAt(oldIndex)
      ..insert(newIndex, optics);
    notifyListeners();
    //_simulationRepository.runSimulation();*/
  }

  void removeContent(int index) {
    final optics = currentOpticsList[index];
    _opticsStateAction.deleteOptics(optics);
    notifyListeners();
  }
}
