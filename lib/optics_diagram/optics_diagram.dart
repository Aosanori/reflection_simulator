import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'diagram_item.dart';

import 'optics_diagram_viewModel.dart';

class OpticsDiagram extends HookConsumerWidget {
  const OpticsDiagram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opticsDiagramViewModel = ref.watch(opticsDiagramViewModelProvider);
    final contents = opticsDiagramViewModel.contents;
    return ReorderableListView(
      onReorder: opticsDiagramViewModel.dragAndDrop,
      padding: const EdgeInsets.only(top: 4),
      children: contents
          .asMap()
          .map(
            (index, item) => MapEntry(
              index,
              DiagramItem(
                optics: item,
                index: index,
                onDelete: () => opticsDiagramViewModel.removeContent(index),
                key: Key(item.id),
              ),
            ),
          )
          .values
          .toList(),
    );
  }
}
