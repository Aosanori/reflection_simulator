import 'package:flutter/material.dart';

import 'optics_diagram_viewModel.dart';

class DiagramItem extends StatelessWidget {
  const DiagramItem({
    required this.index,
    required this.onDelete,
    required this.data,
    required Key key,
  }) : super(key: key);
  final int index;
  final void Function() onDelete;
  final OpticsData data;

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
            data.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              height: 1.2,
            ),
          ),
          subtitle: Text('x: ${data.position.x}   y: ${data.position.y}   z: ${data.position.z}   θ: ${data.position.theta}   φ: ${data.position.phi}'),
          onTap: () {
            print(data.name);
          },
        ),
      );
}
