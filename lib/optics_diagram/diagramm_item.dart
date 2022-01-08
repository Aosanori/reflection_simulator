import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiagramItem extends HookConsumerWidget {
  DiagramItem({
    required this.index,
    required this.child,
    required this.onDelete,
    Key? key,
  }) : super(key: key);
  int index;
  final Widget child;
  final void Function(int) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Dismissible(
        background:
            Container(color: Colors.red, child: const Icon(Icons.delete)),
        key: ValueKey<int>(index),
        onDismissed: (direction) {
          onDelete(index);
        },
        child: child,
      );
}
