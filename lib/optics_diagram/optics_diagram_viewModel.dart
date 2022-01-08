import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/view_model_change_notifier.dart';
import 'diagramm_item.dart';

final opticsDiagramViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => OpticsDiagramViewModel(),
);

class OpticsDiagramViewModel extends ViewModelChangeNotifier {
  OpticsDiagramViewModel() {
    // Generate a list
    contents = List.generate(
      7,
      (index) => DiagramItem(
        index: index,
        key: Key(
          index.toString(),
        ),
        onDelete: removeContent,
        child: Text('Item: $index'),
      ),
    );
  }

  late List<DiagramItem> contents;

  void dragAndDrop(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final movedList = contents.removeAt(oldIndex);
    contents.insert(newIndex, movedList);  
    
    notifyListeners();
  }

  void removeContent(int index) {
    contents.removeAt(index);
    notifyListeners();
  }
}
