import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LaserInformation extends HookConsumerWidget {
  const LaserInformation({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Text(
          'Laser Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            height: 1.2,
          ),
        )
        
      ],
    );
  }
}
