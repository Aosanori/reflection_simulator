import 'package:flutter/material.dart';

import '../beam_information/beam.dart';
import '../optics_diagram/optics.dart';
import 'graph.dart';

const beamTypes = <String>['Gaussian beam'];

const opticsTypes = <String>['Mirror', 'PBS'];

const adjustableAngleOfBeam = 5;
const adjustableAngleOfMirror = 5;

const branchColor = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple
];

// 基本球座標
// ただしx-y平面の曲座標をθとしている()
// θは-180~180とする
final Beam initialBeam = Beam(
  type: 'Gaussian beam',
  waveLength: 800,
  beamWaist: 1,
  startFrom: OpticsPosition(x: 0, y: 100, z: 0, theta: 0, phi: 90),
);

// リスト項目
final List<Optics> initialOpticsList = <Optics>[
  PolarizingBeamSplitter(
    'item1',
    'PBS2',
    OpticsPosition(x: 300, y: 100, z: 0, theta: -135.1, phi: 90.1),
  ),
  Mirror(
    'item2',
    'M1',
    OpticsPosition(x: 300, y: -100, z: 0, theta: 45, phi: 90),
  ),
  Mirror(
    'item3',
    'M2',
    OpticsPosition(x: 500, y: -100, z: 0, theta: 135, phi: 90),
  ),
  PolarizingBeamSplitter(
    'item4',
    'PBS3',
    OpticsPosition(x: 500, y: 100, z: 0, theta: -45.2, phi: 90.2),
  ),
  Mirror(
    'item5',
    'M3',
    OpticsPosition(x: 700, y: 100, z: 0, theta: 180, phi: 90),
  ),
  PolarizingBeamSplitter(
    'item6',
    'PBS1',
    OpticsPosition(x: 100, y: 100, z: 0, theta: 45, phi: 90),
  ),
  Mirror(
    'item7',
    'M4',
    OpticsPosition(x: 100, y: 200, z: 0, theta: -90, phi: 90),
  ),
];
// nodeのidはintで
final initialOpticsTree = Graph<Optics>(
  {
    Node(
      0.toString(),
      initialOpticsList[0],
      // どこと繋がっているか
    ): [
      Node(
        7.toString(),
        initialOpticsList[4],
      ),
      Node(
        1.toString(),
        initialOpticsList[1],
      ),
    ],
    Node(
      1.toString(),
      initialOpticsList[1],
    ): [
      Node(
        2.toString(),
        initialOpticsList[2],
      )
    ],
    Node(
      2.toString(),
      initialOpticsList[2],
    ): [
      Node(
        3.toString(),
        initialOpticsList[3],
      ),
    ],
    Node(
      3.toString(),
      initialOpticsList[3],
    ): [
      null,
      Node(
        4.toString(),
        initialOpticsList[4],
      )
    ],
    Node(
      4.toString(),
      initialOpticsList[4],
    ): [
      Node(
        5.toString(),
        initialOpticsList[5],
      ),
    ],
    Node(
      5.toString(),
      initialOpticsList[5],
    ): [
      null,
      Node(
        6.toString(),
        initialOpticsList[6],
      ),
    ],
    Node(
      6.toString(),
      initialOpticsList[6],
    ): [],
    Node(
      7.toString(),
      initialOpticsList[4],
    ): [
      Node(
        8.toString(),
        initialOpticsList[3],
      )
    ],
    Node(
      8.toString(),
      initialOpticsList[3],
    ): [
      null,
      Node(
        9.toString(),
        initialOpticsList[2],
      ),
    ],
    Node(
      9.toString(),
      initialOpticsList[2],
    ): [
      Node(
        10.toString(),
        initialOpticsList[1],
      )
    ],
    Node(
      10.toString(),
      initialOpticsList[1],
    ): [
      Node(
        11.toString(),
        initialOpticsList[0],
      )
    ],
    Node(
      11.toString(),
      initialOpticsList[0],
    ): [
      null,
      Node(
        12.toString(),
        initialOpticsList[5],
      )
    ],
    Node(
      12.toString(),
      initialOpticsList[5],
    ): [
      null,
      Node(
        13.toString(),
        initialOpticsList[6],
      ),
    ],
    Node(
      13.toString(),
      initialOpticsList[6],
    ): []
  },
);
