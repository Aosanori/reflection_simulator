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

  final double x;
  final double y;
  final double z;
  final double theta;
  final double phi;
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
      'item1', 'Mirror 1', OpticsPosition(x: 500, y: 100, z: 0, theta: 135, phi: 0)),
  OpticsData(
      'item2', 'Mirror 2', OpticsPosition(x: 500, y: -100, z: 0, theta: 45, phi:20)),
  OpticsData(
      'item3', 'Mirror 3', OpticsPosition(x: 300, y: -100, z: 200, theta: 135, phi: 10)),
  OpticsData(
      'item4', 'Mirror 4', OpticsPosition(x: 300, y: 200, z: 0, theta: 45, phi: 0)),
  OpticsData(
      'item5', 'Mirror 5', OpticsPosition(x: 700, y: 200, z: 100, theta: 135, phi: 20)),
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
