import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart' as gv;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/graph.dart';
import '../optics.dart';
import 'optics_tree_view_viewModel.dart';

class OpticsTreeView extends HookConsumerWidget {
  const OpticsTreeView({Key? key}) : super(key: key);

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
          algorithm: gv.BuchheimWalkerAlgorithm(
              viewModel.builder, gv.TreeEdgeRenderer(viewModel.builder),),
          paint: Paint()
            ..color = Colors.green
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke,
          builder: (node) {
            final opticsNode =
                viewModel.getOpticsNodeFromGraph(node.key!.value as int);
            return _OpticsTreeViewItem(opticsNode);
          },
        ),
      ),
    );
  }
}

class _OpticsTreeViewItem extends HookConsumerWidget {
  const _OpticsTreeViewItem(this.opticsNode, {Key? key}) : super(key: key);
  final Node opticsNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(opticsTreeViewViewModelProvider);
    return InkWell(
      onTap: () async {
        if ((opticsNode.data.runtimeType == PolarizingBeamSplitter &&
                viewModel.currentOpticsTree.nodes[opticsNode]!.contains(null)) ||
            (opticsNode.data.runtimeType == Mirror &&
                viewModel.currentOpticsTree.nodes[opticsNode]!.isEmpty)) {
          await showDialog<AlertDialog>(
            context: context,
            builder: (_) => _CreateOpticsRelationDialog(opticsNode),
          );
        }
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
          opticsNode.data.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _CreateOpticsRelationDialog extends HookConsumerWidget {
  _CreateOpticsRelationDialog(this.opticsNode, {Key? key}) : super(key: key);
  final Node opticsNode;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(opticsTreeItemViewModelProvider(opticsNode));

    return AlertDialog(
      title: const Text(
        'Create Optics Relation',
      ),
      content: SingleChildScrollView(
        reverse: true,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('To: '),
                  DropdownButton<Optics>(
                    value: viewModel.connectTo,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    onChanged: viewModel.changeConnectTo,
                    items: viewModel.currentOpticsList
                        .map<DropdownMenuItem<Optics>>(
                          (value) => DropdownMenuItem<Optics>(
                            value: value,
                            child: Text(value.name),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Action: '),
                  DropdownButton<String>(
                    value: viewModel.currentAction,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    onChanged: viewModel.changeAction,
                    items: viewModel.action
                        .map<DropdownMenuItem<String>>(
                          (value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              viewModel.createRelation();
              Navigator.pop(context);
            }
          },
          child: const Text('connect'),
        ),
      ],
    );
  }
}
