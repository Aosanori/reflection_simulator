import '../beam_information/beam.dart';
import '../optics_diagram/optics.dart';

const beamTypes = <String>['Gaussian beam'];

const opticsTypes = <String>['Mirror', 'PBS'];

const adjustableAngleOfBeam = 5;
const adjustableAngleOfMirror = 5;

// 基本球座標
// ただしx-y平面の曲座標をθとしている()
// θは-180~180とする
final Beam initialBeam = Beam(
  type: 'Gaussian beam',
  waveLength: 800,
  beamWaist: 10,
  startFrom: OpticsPosition(x: 0, y: 100, z: 0, theta: 0.4, phi: 90),
);

// リスト項目
final List<Optics> initialOpticsList = <Optics>[
  Optics(
    'item1',
    'M1',
    OpticsPosition(x: 500, y: 100, z: 0, theta: -135, phi: 89.5),
    'Mirror',
  ),
  Optics(
    'item2',
    'M2',
    OpticsPosition(x: 500, y: -100, z: 0, theta: 135, phi: 90.3),
    'Mirror',
  ),
  Optics(
    'item3',
    'M3',
    OpticsPosition(x: 300, y: -100, z: 0, theta: 45, phi: 90),
    'Mirror',
  ),
  Optics(
    'item4',
    'M4',
    OpticsPosition(x: 300, y: 200, z: 0, theta: -45, phi: 90),
    'Mirror',
  ),
  Optics(
    'item5',
    'M5',
    OpticsPosition(x: 700, y: 200, z: 0, theta: -135, phi: 90),
    'Mirror',
  ),
];
