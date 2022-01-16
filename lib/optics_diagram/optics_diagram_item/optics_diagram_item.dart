import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../utils/environments_variables.dart';

import 'optics_diagram_item_viewModel.dart';

class OpticsDiagramItem extends HookConsumerWidget {
  const OpticsDiagramItem({
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
    final rangeOfTheta = opticsDiagramItemViewModel.rangeOfTheta;
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
        subtitle: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            'x: ${optics.position.x} mm   y: ${optics.position.y} mm  z: ${optics.position.z} mm  θ: ${optics.position.theta}°   φ: ${optics.position.phi}°   size: ${optics.size} mm',
            style: const TextStyle(color: Colors.black54),
          ),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'θ: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 1.2,
                ),
              ),
              Expanded(
                child: Slider(
                  label: optics.position.theta.toString(),
                  min: rangeOfTheta[0],
                  max: rangeOfTheta[1],
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
              const Text(
                'φ: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 1.2,
                ),
              ),
              Expanded(
                child: Slider(
                  label: optics.position.phi.toString(),
                  min: 90.0 - adjustableAngleOfMirror,
                  max: 90.0 + adjustableAngleOfMirror,
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
