import 'package:flutter/material.dart';

import 'beam_position/beam_position.dart';

class BeamInformationDisplay extends StatelessWidget {
  const BeamInformationDisplay({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Expanded(
        child: BeamPositionDisplay(),
      );
}
