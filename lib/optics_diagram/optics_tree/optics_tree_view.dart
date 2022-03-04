import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart' as gv;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../create_optics/create_optics_dialog.dart';
import 'create_first_node_dialog.dart/create_first_node_dialog.dart';
import 'optics_tree_view_item/optics_tree_view_item.dart';
import 'optics_tree_view_viewModel.dart';

class OpticsTreeView extends HookConsumerWidget {
  const OpticsTreeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(opticsTreeViewViewModelProvider);
    return Scaffold(
      body: viewModel.graph.nodes.isNotEmpty
          ? InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(100),
              minScale: 0.01,
              maxScale: 5.6,
              child: gv.GraphView(
                graph: viewModel.graph,
                algorithm: gv.BuchheimWalkerAlgorithm(
                  viewModel.builder,
                  gv.TreeEdgeRenderer(viewModel.builder),
                ),
                paint: Paint()
                  ..color = Colors.green
                  ..strokeWidth = 1
                  ..style = PaintingStyle.stroke,
                builder: (node) {
                  final opticsNode = viewModel
                      .getOpticsNodeFromGraph(node.key!.value as String);
                  return OpticsTreeViewItem(opticsNode);
                },
              ),
            )
          : Center(
              child: TextButton(
                onPressed: () async {
                  await showDialog<CreateOpticsDialog>(
                    context: context,
                    builder: (_) => CreateOpticsDialog(),
                  );
                },
                child: const Text('Create Optics'),
              ),
            ),
    );
  }
}
