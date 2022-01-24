import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/view_model_change_notifier.dart';
import '../../simulation/optics_state.dart';
import '../../simulation/simulation_state_store_service.dart';
import '../optics.dart';

final opticsListViewViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => OpticsListViewViewModel(
      ref.watch(simulationStateStoreProvider), ref.watch(opticsStateActionProvider),),
);

class OpticsListViewViewModel extends ViewModelChangeNotifier {
  OpticsListViewViewModel(this._simulationStateStore, this._opticsStateAction);
  final SimulationStateStore _simulationStateStore;
  final OpticsStateAction _opticsStateAction;
  List<Optics> get currentOpticsList =>
      _simulationStateStore.state.currentOpticsList;

  void dragAndDrop(int oldIndex, int newIndex) {
    /*if (newIndex > oldIndex) {
      // 元々下にあった要素が上にずれるため一つ分後退させる
      // ignore: parameter_assignments
      newIndex -= 1;
    }

    // 並び替え処理
    final optics = _simulationStateStore.state.currentOpticsList[oldIndex];
    _simulationStateStore.state.currentOpticsList
      ..removeAt(oldIndex)
      ..insert(newIndex, optics);
    notifyListeners();
    //_simulationStateStore.runSimulation();*/
  }

  void removeContent(int index) {
    _opticsStateAction.deleteOptics(index);
    notifyListeners();
  }
}
