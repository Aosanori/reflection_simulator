import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reflection_simulator/optics_diagram/optics.dart';
import '../common/optics_input_dialog_input_field.dart';
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
                    onChanged: createOpticsDialogViewModel.changeOpticsType,
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
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Connect to: '),
                  DropdownButton<String>(
                    value: createOpticsDialogViewModel.currentConnectOptics,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    onChanged: createOpticsDialogViewModel.changeConnectOptics,
                    items: createOpticsDialogViewModel.currentTreeList
                        .map<DropdownMenuItem<String>>(
                          (value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),*/
              OpticsDialogInputField(
                labelText: 'Optics Name',
                suffixText: '',
                maxLength: 20,
                onChanged: createOpticsDialogViewModel.changeValueOfName,
                isExpectedInteger: false,
              ),
              OpticsDialogInputField(
                labelText: 'x',
                suffixText: 'mm',
                maxLength: 4,
                onChanged: createOpticsDialogViewModel.changeValueOfX,
              ),
              OpticsDialogInputField(
                labelText: 'y',
                suffixText: 'mm',
                maxLength: 4,
                onChanged: createOpticsDialogViewModel.changeValueOfY,
              ),
              OpticsDialogInputField(
                labelText: 'z',
                suffixText: 'mm',
                maxLength: 4,
                onChanged: createOpticsDialogViewModel.changeValueOfZ,
              ),
              OpticsDialogInputField(
                labelText: 'theta',
                hintText: '0° ~ 360',
                suffixText: '°',
                maxLength: 3,
                onChanged: createOpticsDialogViewModel.changeValueOfTheta,
              ),
              OpticsDialogInputField(
                labelText: 'phi',
                hintText: '0° ~ 180',
                suffixText: '°',
                maxLength: 3,
                onChanged: createOpticsDialogViewModel.changeValueOfPhi,
              ),
              OpticsDialogInputField(
                labelText: 'size',
                suffixText: 'mm',
                maxLength: 4,
                onChanged: createOpticsDialogViewModel.changeValueOfSize,
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
              createOpticsDialogViewModel.addOptics();
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}