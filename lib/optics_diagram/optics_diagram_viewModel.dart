import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reflection_simulator/simulation/simulation_provider.dart';

import '../common/view_model_change_notifier.dart';
import '../utils/environments_variables.dart';
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
    opticsList
      ..removeAt(oldIndex)
      ..insert(newIndex, optics);
    notifyListeners();
  }

  void removeContent(int index) {
    _simulationService.currentOpticsList.removeAt(index);
    notifyListeners();
  }
}
