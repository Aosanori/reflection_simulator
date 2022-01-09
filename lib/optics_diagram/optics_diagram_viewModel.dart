import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/view_model_change_notifier.dart';

class OpticsPosition {
  OpticsPosition({
    required this.x,
    required this.y,
    required this.z,
    required this.theta,
    required this.phi,
  });

  final num x;
  final num y;
  final num z;
  final num theta;
  final num phi;
}

// リスト項目のデータ構造
class OpticsData {
  OpticsData(this.id, this.name, this.position);
  String id;
  String name;
  OpticsPosition position;
}

// リスト項目
List<OpticsData> dataList = <OpticsData>[
  OpticsData(
      'item1', 'Mirror 1', OpticsPosition(x: 0, y: 0, z: 0, theta: 40, phi: 0)),
  OpticsData(
      'item2', 'Mirror 2', OpticsPosition(x: 0, y: 10, z: 0, theta: 40, phi:20)),
  OpticsData(
      'item3', 'Mirror 3', OpticsPosition(x: 0, y: 0, z: 20, theta: 40, phi: 10)),
  OpticsData(
      'item4', 'Mirror 4', OpticsPosition(x: 30, y: 0, z: 0, theta: 0, phi: 0)),
];

final opticsDiagramViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => OpticsDiagramViewModel(),
);

class OpticsDiagramViewModel extends ViewModelChangeNotifier {
  OpticsDiagramViewModel() {
    // Generate a list
    contents = dataList;
  }

  late List<OpticsData> contents;

  void dragAndDrop(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      // 元々下にあった要素が上にずれるため一つ分後退させる
      // ignore: parameter_assignments
      newIndex -= 1;
    }

    // 並び替え処理
    final data = contents[oldIndex];
    dataList
      ..removeAt(oldIndex)
      ..insert(newIndex, data);
    notifyListeners();
  }

  void removeContent(int index) {
    contents.removeAt(index);
    notifyListeners();
  }
}
