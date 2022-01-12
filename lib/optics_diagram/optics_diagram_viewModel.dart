import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/view_model_change_notifier.dart';
import '../simulation/simulation_service.dart';
import 'optics.dart';

final opticsDiagramViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => OpticsDiagramViewModel(ref.watch(simulationServiceProvider)),
);

class OpticsDiagramViewModel extends ViewModelChangeNotifier {
  OpticsDiagramViewModel(this._simulationService);
  final SimulationService _simulationService;
  List<Optics> get currentOpticsList => _simulationService.currentOpticsList;

  void dragAndDrop(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      // 元々下にあった要素が上にずれるため一つ分後退させる
      // ignore: parameter_assignments
      newIndex -= 1;
    }

    // 並び替え処理
    final optics = _simulationService.currentOpticsList[oldIndex];
    _simulationService.currentOpticsList
      ..removeAt(oldIndex)
      ..insert(newIndex, optics);
    notifyListeners();
    _simulationService.runSimulation();
  }

  void removeContent(int index) {
    _simulationService.currentOpticsList.removeAt(index);
    notifyListeners();
    _simulationService.runSimulation();
  }
}


// TODO: PreviousPositionはStateNotifier
// TODO: ミラーの上下方向の差分がうまくできてない
