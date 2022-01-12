import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../utils/environments_variables.dart';

import 'create_optics_dialog_viewModel.dart';

class CreateOpticsDialog extends HookConsumerWidget {
  const CreateOpticsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createOpticsDialogViewModel =
        ref.watch(createOpticsDialogViewModelProvider);
    return AlertDialog(
      title: const Text(
        'Add Optics',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
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
              //beamInformationDisplayViewModel.changeBeamType(newValue!);
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
          TextField(
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              labelText: "x",
              suffixText: 'mm',
            ),
            autofocus: true,
            keyboardType: TextInputType.number,
          ),
          TextField(
            textAlign: TextAlign.end,
            decoration: InputDecoration(
             labelText: 'y',
              suffixText: 'mm',
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            textAlign: TextAlign.end,
            decoration: InputDecoration(
             labelText: 'z',
              suffixText: 'mm',
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              labelText:'theta',
              hintText: '0° ~ 360',
              suffixText: '°',
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              labelText: 'phi',
              hintText: '0° ~ 180',
              suffixText: '°',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
