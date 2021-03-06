import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../create_optics/create_optics_dialog.dart';
import '../optics_diagram_item/optics_diagram_item.dart';

import 'optics_list_view_ViewModel.dart';

class OpticsListView extends HookConsumerWidget {
  const OpticsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(opticsListViewViewModelProvider);
    final currentOpticsList = viewModel.currentOpticsList;
    return Scaffold(
      body: ReorderableListView(
        onReorder: viewModel.dragAndDrop,
        buildDefaultDragHandles: false,
        padding: const EdgeInsets.only(top: 4),
        children: currentOpticsList
            .asMap()
            .map(
              (index, item) => MapEntry(
                index,
                OpticsDiagramItem(
                  index: index,
                  onDelete: () => viewModel.removeContent(index),
                  key: Key(item.id),
                ),
              ),
            )
            .values
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<CreateOpticsDialog>(
          context: context,
          builder: (_) => CreateOpticsDialog(),
        ),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
