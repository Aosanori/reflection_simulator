import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reflection_simulator/create_optics/create_optics_relation_dialog.dart';

class OpticsTreeView extends HookConsumerWidget {
  const OpticsTreeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        body: Container(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog<CreateOpticsRelationDialog>(
            context: context,
            builder: (_) => CreateOpticsRelationDialog(),
          ),
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
}
