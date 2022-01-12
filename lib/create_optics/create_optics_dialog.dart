import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'create_optics_dialog_viewModel.dart';

class CreateOpticsDialog extends HookConsumerWidget {
  const CreateOpticsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createOpticsDialogViewModel =
        ref.watch(createOpticsDialogViewModelProvider);
    return AlertDialog(
      title: Text(
        'TITLE',
        // style: TextStyle(fontFamily: "Smash"),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: 'field1',
            ),
            autofocus: true,
            // keyboardType: TextInputType.number,
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'field2',
            ),
            autofocus: false,
            // keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('キャンセル'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('追加'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
