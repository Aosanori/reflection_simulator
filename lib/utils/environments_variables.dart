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
  startFrom: OpticsPosition(x: 0, y: 100, z: 0, theta: 0, phi: 90),
);

// リスト項目
final List<Optics> initialOpticsList = <Optics>[
  PolarizingBeamSplitter(
    'item1',
    'PBS1',
    OpticsPosition(x: 300, y: 100, z: 0, theta: -135, phi: 90),
  ),
  Mirror(
    'item2',
    'M2',
    OpticsPosition(x: 300, y: -100, z: 0, theta: 45, phi: 90),
  ),
  Mirror(
    'item3',
    'M3',
    OpticsPosition(x: 500, y: -100, z: 0, theta: 135, phi: 90),
  ),
  PolarizingBeamSplitter(
    'item4',
    'PBS2',
    OpticsPosition(x: 500, y: 100, z: 0, theta: -45, phi: 90),
  ),
  Mirror(
    'item5',
    'M5',
    OpticsPosition(x: 700, y: 100, z: 0, theta: 180, phi: 90),
  ),
  Mirror(
    'item6',
    'M6',
    OpticsPosition(x: 100, y: 100, z: 0, theta: 45, phi: 90),
  ),
  Mirror(
    'item7',
    'M7',
    OpticsPosition(x: 100, y: 200, z: 0, theta: -90, phi: 90),
  ),
];
