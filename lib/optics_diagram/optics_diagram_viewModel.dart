import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/view_model_change_notifier.dart';

// リスト項目のデータ構造
class MyData {
  String id;
  String name;
  int age;

  MyData(this.id, this.name, this.age);
}

// リスト項目
List<MyData> dataList = <MyData>[
  MyData('item1', 'A', 23),
  MyData('item2', 'B', 26),
  MyData('item3', 'C', 35),
  MyData('item4', 'D', 42),
];

final opticsDiagramViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => OpticsDiagramViewModel(),
);

class OpticsDiagramViewModel extends ViewModelChangeNotifier {
  OpticsDiagramViewModel() {
    // Generate a list
    contents = dataList;
  }

  late List<MyData> contents;
  ///late List<

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

  void genarateTile(){

  }
}
