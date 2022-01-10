import 'package:flutter/material.dart';

import 'optics.dart';
import 'optics_diagram_viewModel.dart';

class DiagramItem extends StatelessWidget {
  const DiagramItem({
    required this.index,
    required this.onDelete,
    required this.optics,
    required Key key,
  }) : super(key: key);
  final int index;
  final void Function() onDelete;
  final Optics optics;

  @override
  Widget build(BuildContext context) => Dismissible(
        key: key!, // 項目が特定できるよう固有の文字列をキーとする
        background: Container(color: Colors.red), // スワイプしているアイテムの背景色
        onDismissed: (direction) {
          // 削除時の処理
          onDelete();
        },
        // 各項目のレイアウト
        child: ListTile(
          tileColor: Theme.of(context).cardColor,
          title: Text(
            optics.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              height: 1.2,
            ),
          ),
          subtitle: Text(
              'x: ${optics.position.x}   y: ${optics.position.y}   z: ${optics.position.z}   θ: ${optics.position.theta}   φ: ${optics.position.phi}'),
          onTap: () {
            print(optics.name);
          },
        ),
      );
}
