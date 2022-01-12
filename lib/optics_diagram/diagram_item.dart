import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'optics_diagram_viewModel.dart';

class DiagramItem extends HookConsumerWidget {
  const DiagramItem({
    required this.index,
    required this.onDelete,
    required Key key,
  }) : super(key: key);
  final int index;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opticsDiagramItemViewModel =
        ref.watch(opticsDiagramItemViewModelProvider(index));
    final optics = opticsDiagramItemViewModel.optics;
    return Dismissible(
      key: key!, // 項目が特定できるよう固有の文字列をキーとする
      background: Container(color: Colors.red), // スワイプしているアイテムの背景色
      onDismissed: (direction) {
        // 削除時の処理
        onDelete();
      },
      // 各項目のレイアウト
      child: ExpansionTile(
        title: Text(
          optics.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            height: 1.2,
          ),
        ),
        subtitle: Text(
          'x: ${optics.position.x}   y: ${optics.position.y}   z: ${optics.position.z}   θ: ${optics.position.theta}   φ: ${optics.position.phi}',
          style: const TextStyle(color: Colors.black54),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('θ: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 1.2,
                ),
              ),
              Expanded(
                child: Slider(
                  label: optics.position.theta.toString(),
                  max: 360,
                  value: optics.position.theta,
                  activeColor: Colors.orange,
                  inactiveColor: Colors.blueAccent,
                  onChanged: (value) {
                    opticsDiagramItemViewModel.changeTheta(index, value);
                  }, /*onChangeStart: _startSlider*/
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('φ: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 1.2,
                ),
              ),
              Expanded(
                child: Slider(
                  label: optics.position.phi.toString(),
                  max: 180,
                  value: optics.position.phi,
                  activeColor: Colors.orange,
                  inactiveColor: Colors.blueAccent,
                  onChanged: (value) {
                    opticsDiagramItemViewModel.changePhi(index, value);
                  }, /*onChangeStart: _startSlider*/
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
