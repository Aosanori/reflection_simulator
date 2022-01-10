import '../beam_information/beam.dart';
import '../optics_diagram/optics.dart';

const beamTypes = <String>['Gaussian beam'];

Beam example_beam = Beam(
  type: 'Gaussian beam',
  waveLength: 800,
  beamWaist: 10,
);

// リスト項目
List<Optics> opticsList = <Optics>[
  Optics('item1', 'Mirror 1',
      OpticsPosition(x: 500, y: 100, z: 0, theta: 135, phi: 0)),
  Optics('item2', 'Mirror 2',
      OpticsPosition(x: 500, y: -100, z: 0, theta: 45, phi: 20)),
  Optics('item3', 'Mirror 3',
      OpticsPosition(x: 300, y: -100, z: 200, theta: 135, phi: 10)),
  Optics('item4', 'Mirror 4',
      OpticsPosition(x: 300, y: 200, z: 0, theta: 45, phi: 0)),
  Optics('item5', 'Mirror 5',
      OpticsPosition(x: 700, y: 200, z: 100, theta: 135, phi: 20)),
];
