import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart' as gv;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../create_optics/create_optics_relation_dialog.dart';
import '../optics.dart';
import 'optics_tree_view_viewModel.dart';

class OpticsTreeView extends HookConsumerWidget {
  const OpticsTreeView({Key? key}) : super(key: key);

  Widget rectangleWidget(Optics optics) => InkWell(
        onTap: () {
          print('clicked');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 3,
              ),
              top: BorderSide(
                width: 3,
              ),
              right: BorderSide(
                width: 3,
              ),
              bottom: BorderSide(
                width: 3,
              ),
            ),
          ),
          child: Text(
            optics.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(opticsTreeViewViewModelProvider);
    return Scaffold(
      body: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.01,
        maxScale: 5.6,
        child: gv.GraphView(
          graph: viewModel.graph,
          algorithm:
              gv.BuchheimWalkerAlgorithm(viewModel.builder, gv.TreeEdgeRenderer(viewModel.builder)),
          paint: Paint()
            ..color = Colors.green
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke,
          builder: (node) {
            final optics = viewModel.getOpticsFromGraph(node.key!.value as int);
            return rectangleWidget(optics);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<CreateOpticsRelationDialog>(
          context: context,
          builder: (_) => CreateOpticsRelationDialog(),
        ),
        tooltip: 'Create Relation',
        child: const Icon(Icons.add),
      ),
    );
  }
}
