import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../common/optics_input_dialog_input_field.dart';
import '../utils/environments_variables.dart';
import 'edit_optics_dialog_viewModel.dart';

class EditOpticsDialog extends HookConsumerWidget {
  EditOpticsDialog({
    required this.index,
    Key? key,
  }) : super(key: key);
  final int index;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editOpticsDialogViewModel =
        ref.watch(editOpticsDialogViewModelProvider(index));
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
                    value: editOpticsDialogViewModel.editOptics.type,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    onChanged: editOpticsDialogViewModel.changeOpticsType,
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
              OpticsDialogInputField(
                labelText: 'Optics Name',
                suffixText: '',
                maxLength: 20,
                onChanged: editOpticsDialogViewModel.changeValueOfName,
                initialValue: editOpticsDialogViewModel.editOptics.name,
                isExpectedInteger: false,
              ),
              OpticsDialogInputField(
                labelText: 'x',
                suffixText: 'mm',
                onChanged: editOpticsDialogViewModel.changeValueOfX,
                initialValue:
                    editOpticsDialogViewModel.editOptics.position.x.toString(),
              ),
              OpticsDialogInputField(
                labelText: 'y',
                suffixText: 'mm',
                onChanged: editOpticsDialogViewModel.changeValueOfY,
                initialValue:
                    editOpticsDialogViewModel.editOptics.position.y.toString(),
              ),
              OpticsDialogInputField(
                labelText: 'z',
                suffixText: 'mm',
                onChanged: editOpticsDialogViewModel.changeValueOfZ,
                initialValue:
                    editOpticsDialogViewModel.editOptics.position.z.toString(),
              ),
              /*OpticsDialogInputField(
                labelText: 'theta',
                hintText: '0° ~ 360',
                suffixText: '°',
                onChanged: editOpticsDialogViewModel.changeValueOfTheta,
                initialValue: editOpticsDialogViewModel
                    .editOptics.position.theta
                    .toString(),
              ),
              OpticsDialogInputField(
                labelText: 'phi',
                hintText: '0° ~ 180',
                suffixText: '°',
                onChanged: editOpticsDialogViewModel.changeValueOfPhi,
                initialValue: editOpticsDialogViewModel.editOptics.position.phi
                    .toString(),
              ),*/
              OpticsDialogInputField(
                labelText: 'size',
                suffixText: 'mm',
                onChanged: editOpticsDialogViewModel.changeValueOfSize,
                initialValue:
                    editOpticsDialogViewModel.editOptics.size.toString(),
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
              editOpticsDialogViewModel.addToDiagram();
              Navigator.pop(context);
            }
          },
          child: const Text('save'),
        ),
      ],
    );
  }
}
