import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/view_model_change_notifier.dart';
import '../utils/environments_variables.dart';
import 'optics.dart';

final opticsDiagramViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => OpticsDiagramViewModel(),
);

class OpticsDiagramViewModel extends ViewModelChangeNotifier {
  OpticsDiagramViewModel() {
    // Generate a list
    contents = opticsList;
  }

  late List<Optics> contents;

  void dragAndDrop(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      // 元々下にあった要素が上にずれるため一つ分後退させる
      // ignore: parameter_assignments
      newIndex -= 1;
    }

    // 並び替え処理
    final optics = contents[oldIndex];
    opticsList
      ..removeAt(oldIndex)
      ..insert(newIndex, optics);
    notifyListeners();
  }

  void removeContent(int index) {
    contents.removeAt(index);
    notifyListeners();
  }
}
