import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/view_model_change_notifier.dart';

final opticsDiagramViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => OpticsDiagramViewModel(),
);

class OpticsDiagramViewModel extends ViewModelChangeNotifier {
  OpticsDiagramViewModel() {
    // Generate a list
    contents = List.generate(
      10,
      (index) => DragAndDropList(
        header: Text('Header $index'),
        children: <DragAndDropItem>[
          DragAndDropItem(
            child: Text('$index.1'),
          ),
          DragAndDropItem(
            child: Text('$index.2'),
          ),
          DragAndDropItem(
            child: Text('$index.3'),
          ),
        ],
      ),
    );
  }

  late List<DragAndDropList> contents;

  void onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    final movedItem = contents[oldListIndex].children.removeAt(oldItemIndex);
    contents[newListIndex].children.insert(newItemIndex, movedItem);
    notifyListeners();
  }

  void onListReorder(int oldListIndex, int newListIndex) {
    final movedList = contents.removeAt(oldListIndex);
    contents.insert(newListIndex, movedList);
    notifyListeners();
  }
}
