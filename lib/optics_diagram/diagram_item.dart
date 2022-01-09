import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'optics_diagram_viewModel.dart';

class DiagramItem extends HookConsumerWidget {
  const DiagramItem({
    required this.index,
    required this.onDelete,
    required this.data,
    Key? key,
  }) : super(key: key);
  final int index;
  final void Function() onDelete;
  final MyData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Dismissible(
        key: Key(data.id), // 項目が特定できるよう固有の文字列をキーとする
        background: Container(color: Colors.red), // スワイプしているアイテムの背景色
        onDismissed: (direction) {
          // 削除時の処理
          onDelete();
        },
        // 各項目のレイアウト
        child: ListTile(
          tileColor: Theme.of(context).cardColor,
          title: Text(
            data.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              height: 1.2,
            ),
          ),
          subtitle: Text('AGE: ${data.age}'),
          onTap: () {
            print(data.name);
          },
        ),
      );
}
