import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../utils/graph.dart';

import '../../optics.dart';
import '../optics_tree_view_viewModel.dart';
import 'optics_tree_view_item_viewModel.dart';



class OpticsTreeViewItem extends HookConsumerWidget {
  const OpticsTreeViewItem(this.opticsNode, {Key? key}) : super(key: key);
  final Node opticsNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(opticsTreeViewViewModelProvider);
    final nextOpticsList = viewModel.currentOpticsTree.nodes[opticsNode]!;
    return InkWell(
      onTap: () async {
        if ((opticsNode.data.runtimeType == PolarizingBeamSplitter &&
                nextOpticsList.contains(null)) ||
            (opticsNode.data.runtimeType == Mirror &&
                (nextOpticsList.isEmpty ||
                    listEquals(nextOpticsList, [null]) ||
                    listEquals(nextOpticsList, [null, null])))) {
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
    final nodes = viewModel.currentOpticsTree.nodes[opticsNode];
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
                    items: viewModel.availableToConnectOptics
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ((nodes?.isEmpty ?? false) ||
                    listEquals(nodes, [null, null]) ||
                    listEquals(nodes, [null]))
                ? TextButton(
                    onPressed: () {
                      viewModel.deleteNode();
                      Navigator.pop(context);
                    },
                    child: Text('delete',
                        style: TextStyle(color: Color(Colors.red.value))),
                  )
                : const SizedBox(width: 0, height: 0),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 5),
                  child: TextButton(
                    child: const Text('cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
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
            )
          ],
        )
      ],
    );
  }
}
