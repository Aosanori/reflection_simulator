import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'optics_diagram_viewModel.dart';

class OpticsDiagram extends HookConsumerWidget {
  const OpticsDiagram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opticsDiagramViewModel = ref.watch(opticsDiagramViewModelProvider);
    return DragAndDropLists(
      children: opticsDiagramViewModel.contents,
      onItemReorder: opticsDiagramViewModel.onItemReorder,
      onListReorder: opticsDiagramViewModel.onListReorder,
    );
  }
}
