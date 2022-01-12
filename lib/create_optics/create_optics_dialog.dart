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
            _CreateOpticsDialogInputField(
              labelText: 'x',
              suffixText: 'nm',
              maxLength: 4,
              onChanged: (_) {},
            ),
            _CreateOpticsDialogInputField(
              labelText: 'y',
              suffixText: 'nm',
              maxLength: 4,
              onChanged: (_) {},
            ),
            _CreateOpticsDialogInputField(
              labelText: 'z',
              suffixText: 'nm',
              maxLength: 4,
              onChanged: (_) {},
            ),
            _CreateOpticsDialogInputField(
              labelText: 'theta',
              hintText: '0° ~ 360',
              suffixText: '°',
              maxLength: 3,
              onChanged: (_) {},
            ),
            _CreateOpticsDialogInputField(
              labelText: 'phi',
              hintText: '0° ~ 180',
              suffixText: '°',
              maxLength: 3,
              onChanged: (_) {},
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              createOpticsDialogViewModel.addToDiagram();
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class _CreateOpticsDialogInputField extends StatelessWidget {
  const _CreateOpticsDialogInputField({
    required this.labelText,
    required this.suffixText,
    required this.maxLength,
    required this.onChanged,
    this.hintText = '',
    Key? key,
  }) : super(key: key);
  final String labelText;
  final String suffixText;
  final String hintText;
  final int maxLength;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) => TextFormField(
        textAlign: TextAlign.end,
        decoration: InputDecoration(
          labelText: labelText,
          suffixText: suffixText,
          hintText: hintText,
        ),
        autofocus: true,
        maxLength: 4,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Input is empty';
          }

          if (double.tryParse(text) == null) {
            return 'Input must be integer.';
          }
          return null;
        },
      );
}
