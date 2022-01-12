import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../utils/environments_variables.dart';

import 'create_optics_dialog_viewModel.dart';

class CreateOpticsDialog extends HookConsumerWidget {
  CreateOpticsDialog({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createOpticsDialogViewModel =
        ref.watch(createOpticsDialogViewModelProvider);
    return AlertDialog(
      title: const Text(
        'Add Optics',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Optics Type:'),
                DropdownButton<String>(
                  value: createOpticsDialogViewModel.newOptics.type,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: (newValue) {
                    createOpticsDialogViewModel.newOptics.type = newValue!;
                  },
                  items: opticsTypes
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
            TextFormField(
                textAlign: TextAlign.end,
                decoration: const InputDecoration(
                  labelText: 'x',
                  suffixText: 'mm',
                ),
                autofocus: true,
                maxLength: 3,
                keyboardType: TextInputType.number,
                onChanged: (newValue) {
                  createOpticsDialogViewModel.newOptics.type = newValue;
                },),
            TextFormField(
              textAlign: TextAlign.end,
              decoration: const InputDecoration(
                labelText: 'y',
                suffixText: 'mm',
              ),
              maxLength: 4,
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              textAlign: TextAlign.end,
              decoration: const InputDecoration(
                labelText: 'z',
                suffixText: 'mm',
              ),
              maxLength: 3,
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              textAlign: TextAlign.end,
              decoration: const InputDecoration(
                labelText: 'theta',
                hintText: '0° ~ 360',
                suffixText: '°',
              ),
              maxLength: 3,
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              textAlign: TextAlign.end,
              decoration: const InputDecoration(
                labelText: 'phi',
                hintText: '0° ~ 180',
                suffixText: '°',
              ),
              maxLength: 3,
              keyboardType: TextInputType.number,
            ),
          ],
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
          onPressed: createOpticsDialogViewModel.addToDiagram,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
