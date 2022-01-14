import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../utils/environments_variables.dart';

import 'beam_position_viewModel.dart';

class BeamPositionDisplay extends HookConsumerWidget {
  const BeamPositionDisplay({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(beamPositionViewModelProvider);
    final currentBeam = viewModel.currentBeam;
    final rangeOfTheta = viewModel.rangeOfTheta;
    return GestureDetector(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              currentBeam.type,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                height: 1.2,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              'x: ${currentBeam.startFrom.x} mm  y: ${currentBeam.startFrom.y} mm  z: ${currentBeam.startFrom.z} mm   θ: ${currentBeam.startFrom.theta}°  φ: ${currentBeam.startFrom.phi}°',
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              'λ: ${currentBeam.waveLength} nm   beam waist: ${currentBeam.beamWaist} mm',
              style: const TextStyle(color: Colors.black54),
            ),
          ),
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
                  label: viewModel.currentBeam.startFrom.theta.toString(),
                  min: rangeOfTheta != null ? rangeOfTheta[0] : 0,
                  max: rangeOfTheta != null ? rangeOfTheta[1] : 360,
                  //max:360,
                  value: viewModel.currentBeam.startFrom.theta,
                  activeColor: Colors.orange,
                  inactiveColor: Colors.blueAccent,
                  onChanged: viewModel.changeValueOfTheta,
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
                  label: viewModel.currentBeam.startFrom.phi.toString(),
                  min: 90.0 - adjustableAngleOfBeam,
                  max: 90.0 + adjustableAngleOfBeam,
                  value: viewModel.currentBeam.startFrom.phi,
                  activeColor: Colors.orange,
                  inactiveColor: Colors.blueAccent,
                  onChanged: viewModel.changeValueOfPhi,
                ),
              ),
            ],
          )
        ],
      ),
      onTap: () => showDialog<_BeamPositionInputDialog>(
        context: context,
        builder: (_) => _BeamPositionInputDialog(),
      ),
    );
  }
}

class _BeamPositionInputDialog extends HookConsumerWidget {
  _BeamPositionInputDialog({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(beamPositionViewModelProvider);
    final currentBeam = viewModel.currentBeam;
    return AlertDialog(
      title: const Text(
        'Edit Beam',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Beam Type:  '),
                DropdownButton<String>(
                  value: viewModel.currentBeam.type,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: (newValue) {
                    viewModel.changeBeamType(newValue!);
                  },
                  items: beamTypes
                      .map<DropdownMenuItem<String>>(
                        (value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            _BeamPositionInputField(
              labelText: 'x',
              suffixText: 'mm',
              maxLength: 4,
              onChanged: viewModel.changeValueOfX,
              initialValue: currentBeam.startFrom.x.toInt(),
            ),
            _BeamPositionInputField(
              labelText: 'y',
              suffixText: 'mm',
              maxLength: 4,
              onChanged: viewModel.changeValueOfY,
              initialValue: currentBeam.startFrom.y.toInt(),
            ),
            _BeamPositionInputField(
              labelText: 'z',
              suffixText: 'mm',
              maxLength: 4,
              onChanged: viewModel.changeValueOfZ,
              initialValue: currentBeam.startFrom.z.toInt(),
            ),
            _BeamPositionInputField(
              labelText: 'λ',
              hintText: '600 ~ 1000',
              suffixText: 'nm',
              maxLength: 4,
              onChanged: viewModel.changeValueOfWaveLength,
              initialValue: currentBeam.waveLength.toInt(),
            ),
            _BeamPositionInputField(
              labelText: 'beam waist',
              hintText: '0 ~ 100',
              suffixText: 'mm',
              maxLength: 3,
              onChanged: viewModel.changeValueOfBeamWaist,
              initialValue: currentBeam.beamWaist.toInt(),
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              viewModel.runSimulation();
              Navigator.pop(context);
            }
          },
          child: const Text('Run'),
        ),
      ],
    );
  }
}

class _BeamPositionInputField extends StatelessWidget {
  const _BeamPositionInputField({
    required this.labelText,
    required this.suffixText,
    required this.maxLength,
    required this.onChanged,
    this.initialValue = 0,
    this.isExpectedInteger = true,
    this.hintText = '',
    Key? key,
  }) : super(key: key);
  final String labelText;
  final String suffixText;
  final String hintText;
  final int maxLength;
  final int initialValue;
  final bool isExpectedInteger;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) => TextFormField(
        initialValue: initialValue.toString(),
        textAlign: TextAlign.end,
        decoration: InputDecoration(
          labelText: labelText,
          suffixText: suffixText,
          hintText: hintText,
        ),
        autofocus: true,
        maxLength: maxLength,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Input is empty';
          }

          if (isExpectedInteger && double.tryParse(text) == null) {
            return 'Input must be integer.';
          }
          return null;
        },
      );
}
