import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../optics.dart';
import 'create_first_node_dialog_viewModel.dart';

class CreateFirstNodeDialog extends HookConsumerWidget {
  CreateFirstNodeDialog({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(createFirstNodeDialogViewModelProvider);
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
                  const Text('Optics: '),
                  DropdownButton<Optics>(
                    value: viewModel.selectedOptics,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    onChanged: viewModel.changeOptics,
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
              viewModel.addFirstNode();
              Navigator.pop(context);
            }
          },
          child: const Text('create'),
        ),
      ],
    );
  }
}
