import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../optics_diagram/optics.dart';
import '../utils/graph.dart';
import 'create_optics_relation_dialog_viewModel.dart';

class CreateOpticsRelationDialog extends HookConsumerWidget {
  CreateOpticsRelationDialog({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(createOpticsRelationDialogViewModelProvider);
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
                  const Text('From: '),
                  DropdownButton<Node>(
                    value: viewModel.connectFrom,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    onChanged: viewModel.changeConnectFrom,
                    items: viewModel.currentOpticsTree
                        .map<DropdownMenuItem<Node>>(
                          (value) => DropdownMenuItem<Node>(
                            value: value,
                            child: Text('${value.id} ${value.data.name}'),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
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
