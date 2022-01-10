import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../utils/environments_variables.dart';

import 'beam_information_display_viewModel.dart';

class BeamInformationDisplay extends HookConsumerWidget {
  const BeamInformationDisplay({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beamInformationDisplayViewModel =
        ref.watch(beamInformationDisplayViewModelProvider);
    return Column(
      children: [
        const Text(
          'Beam Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            height: 1.2,
          ),
        ),
        DropdownButton<String>(
          value: beamInformationDisplayViewModel.currentBeam.type,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 30,
          elevation: 16,
          underline: Container(
            height: 2,
            color: Colors.grey,
          ),
          onChanged: (newValue) {
            beamInformationDisplayViewModel.changeBeamType(newValue!);
          },
          items: beamTypes
              .map<DropdownMenuItem<String>>(
                (value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ),
              )
              .toList(),
        )
      ],
    );
  }
}
