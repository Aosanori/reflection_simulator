import 'package:flutter/material.dart';

class OpticsDialogInputField extends StatelessWidget {
  const OpticsDialogInputField({
    required this.labelText,
    required this.suffixText,
    required this.onChanged,
    this.maxLength,
    this.initialValue = '',
    this.isExpectedInteger = true,
    this.hintText = '',
    Key? key,
  }) : super(key: key);
  final String labelText;
  final String suffixText;
  final String hintText;
  final int? maxLength;
  final String initialValue;
  final bool isExpectedInteger;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) => TextFormField(
        textAlign: TextAlign.end,
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: labelText,
          suffixText: suffixText,
          hintText: hintText,
        ),
        autofocus: true,
        maxLength: maxLength,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Input is empty';
          }

          if (isExpectedInteger && double.tryParse(text) == null) {
            return 'Input must be integer.';
          }
          return null;
        },
      );
}
