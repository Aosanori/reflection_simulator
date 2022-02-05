import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reflection_simulator/beam_information/beam.dart';
import 'package:reflection_simulator/optics_diagram/optics.dart';
import 'package:reflection_simulator/simulation/simulation_repository.dart';
import 'package:reflection_simulator/simulation/simulation_service.dart';

import 'package:reflection_simulator/utils/environments_variables.dart';
import 'package:reflection_simulator/utils/graph.dart';

void main() {
  group(
    'Simulation Test',
    () {
      test(
        'runSimulationWithChangingValue single thread',
        () {
          final stopwatch = Stopwatch()..start();
          final targetOptics = initialOpticsList[2];
          const targetValue = 'theta';
          final container = ProviderContainer();
          final repository = container.read(simulationRepositoryProvider);
          final results = repository.runSimulationWithChangingValue(
            VariableOfSimulationWithChangingValue(
              targetOptics,
              targetValue,
            ),
          );
          stopwatch.stop();
          expect(stopwatch.elapsed.inMilliseconds < 150, true);
        },
      );
      test(
        'runSimulationWithChangingValue multi thread',
        () async {
          final stopwatch = Stopwatch()..start();
          final targetOptics = initialOpticsList[2];
          const targetValue = 'theta';
          final container = ProviderContainer();
          final repository = container.read(simulationRepositoryProvider);
          final com = await compute(
            repository.runSimulationWithChangingValue,
            VariableOfSimulationWithChangingValue(
              targetOptics,
              targetValue,
            ),
          );
          stopwatch.stop();
          expect(stopwatch.elapsed.inMilliseconds < 150, true);
        },
      );

      test(
        'case 1 (直角反射)',
        () {
          final container = ProviderContainer();
          final testTree = Graph<Optics>(
            {
              Node(
                0.toString(),
                Mirror(
                  'item1',
                  'M1',
                  OpticsPosition(x: 300, y: 100, z: 0, theta: -135, phi: 90),
                ),
                // どこと繋がっているか
              ): [
                Node(
                  1.toString(),
                  Mirror(
                    'item2',
                    'M2',
                    OpticsPosition(x: 300, y: -100, z: 0, theta: 45, phi: 90),
                  ),
                ),
              ],
              Node(
                1.toString(),
                Mirror(
                  'item2',
                  'M2',
                  OpticsPosition(x: 300, y: -100, z: 0, theta: 45, phi: 90),
                ),
              ): [
                Node(
                  2.toString(),
                  Mirror(
                    'item3',
                    'M3',
                    OpticsPosition(x: 500, y: -100, z: 0, theta: 180, phi: 90),
                  ),
                )
              ],
              Node(
                2.toString(),
                Mirror(
                  'item3',
                  'M3',
                  OpticsPosition(x: 500, y: -100, z: 0, theta: 180, phi: 90),
                ),
              ): []
            },
          );
          final result =
              container.read(simulationServiceProvider).runSimulation(
                    currentBeam: initialBeam,
                    currentOpticsTree: testTree,
                  );

          final distanceFromStart =
              result.simulatedBeamList.first.distanceFromStart;
          final position = result.simulatedBeamList.first.startPositionVector;
          expect((distanceFromStart - 700).abs() < 0.001, true);
          expect((position.x - 500).abs() < 0.001, true);
          expect((position.y - (-100)).abs() < 0.001, true);
        },
      );

      test(
        'case 2 (共振器)',
        () {
          final container = ProviderContainer();
          final testBeam = Beam(
            type: 'Gaussian beam',
            waveLength: 800,
            beamWaist: 1,
            startFrom: OpticsPosition(x: 0, y: 0, z: 0, theta: 0, phi: 90),
          );
          final testTree = Graph<Optics>(
            {
              Node(
                0.toString(),
                Mirror(
                  'item1',
                  'M1',
                  OpticsPosition(x: 300, y: 0, z: 0, theta: -180, phi: 90),
                ),
                // どこと繋がっているか
              ): [
                Node(
                  1.toString(),
                  Mirror(
                    'item2',
                    'M2',
                    OpticsPosition(x: -300, y: 0, z: 0, theta: 0, phi: 90),
                  ),
                ),
              ],
              Node(
                1.toString(),
                Mirror(
                  'item2',
                  'M2',
                  OpticsPosition(x: -300, y: 0, z: 0, theta: 0, phi: 90),
                ),
              ): [
                Node(
                  2.toString(),
                  Mirror(
                    'item3',
                    'M3',
                    OpticsPosition(x: 0, y: -0, z: 0, theta: 180, phi: 90),
                  ),
                )
              ],
              Node(
                2.toString(),
                Mirror(
                  'item3',
                  'M3',
                  OpticsPosition(x: 0, y: -0, z: 0, theta: 180, phi: 90),
                ),
              ): []
            },
          );
          final result =
              container.read(simulationServiceProvider).runSimulation(
                    currentBeam: testBeam,
                    currentOpticsTree: testTree,
                  );

          final distanceFromStart =
              result.simulatedBeamList.first.distanceFromStart;
          final position = result.simulatedBeamList.first.startPositionVector;
          expect((distanceFromStart - 1200).abs() < 0.001, true);
          expect((position.x - 0).abs() < 0.001, true);
          expect((position.y - (-0)).abs() < 0.001, true);
        },
      );

      test(
        'case 3 (六角形)',
        () {
          final container = ProviderContainer();
          final testBeam = Beam(
            type: 'Gaussian beam',
            waveLength: 800,
            beamWaist: 1,
            startFrom: OpticsPosition(x: 0, y: 0, z: 0, theta: 0, phi: 90),
          );
          final testTree = Graph<Optics>(
            {
              Node(
                0.toString(),
                Mirror(
                  'item1',
                  'M1',
                  OpticsPosition(x: 100, y: 0, z: 0, theta: 120, phi: 90),
                ),
                // どこと繋がっているか
              ): [
                Node(
                  1.toString(),
                  Mirror(
                    'item2',
                    'M2',
                    OpticsPosition(x: 200, y: 173.2, z: 0, theta: 180, phi: 90),
                  ),
                ),
              ],
              Node(
                1.toString(),
                Mirror(
                  'item2',
                  'M2',
                  OpticsPosition(x: 200, y: 173.2, z: 0, theta: 180, phi: 90),
                ),
              ): [
                Node(
                  2.toString(),
                  Mirror(
                    'item3',
                    'M3',
                    OpticsPosition(
                      x: 100,
                      y: 346.4,
                      z: 0,
                      theta: -120,
                      phi: 90,
                    ),
                  ),
                )
              ],
              Node(
                2.toString(),
                Mirror(
                  'item3',
                  'M3',
                  OpticsPosition(x: 100, y: 346.4, z: 0, theta: -120, phi: 90),
                ),
              ): [
                Node(
                  3.toString(),
                  Mirror(
                    'item4',
                    'M4',
                    OpticsPosition(
                        x: -100, y: 346.4, z: 0, theta: -60, phi: 90),
                  ),
                ),
              ],
              Node(
                3.toString(),
                Mirror(
                  'item4',
                  'M4',
                  OpticsPosition(x: -100, y: 346.4, z: 0, theta: -60, phi: 90),
                ),
              ): [
                Node(
                  4.toString(),
                  Mirror(
                    'item5',
                    'M5',
                    OpticsPosition(x: -200, y: 173.2, z: 0, theta: 0, phi: 90),
                  ),
                ),
              ],
              Node(
                4.toString(),
                Mirror(
                  'item5',
                  'M5',
                  OpticsPosition(x: -200, y: 173.2, z: 0, theta: 0, phi: 90),
                ),
              ): [
                Node(
                  5.toString(),
                  Mirror(
                    'item6',
                    'M6',
                    OpticsPosition(x: -100, y: 0, z: 0, theta: 60, phi: 90),
                  ),
                )
              ],
              Node(
                5.toString(),
                Mirror(
                  'item6',
                  'M6',
                  OpticsPosition(x: -100, y: 0, z: 0, theta: 60, phi: 90),
                ),
              ): [
                Node(
                  6.toString(),
                  Mirror(
                    'item7',
                    'M7',
                    OpticsPosition(x: 0, y: -0, z: 0, theta: 180, phi: 90),
                  ),
                )
              ],
              Node(
                6.toString(),
                Mirror(
                  'item7',
                  'M7',
                  OpticsPosition(x: 0, y: -0, z: 0, theta: 180, phi: 90),
                ),
              ): []
            },
          );
          final result =
              container.read(simulationServiceProvider).runSimulation(
                    currentBeam: testBeam,
                    currentOpticsTree: testTree,
                  );

          final distanceFromStart =
              result.simulatedBeamList.first.distanceFromStart;
          final position = result.simulatedBeamList.first.startPositionVector;
          expect((distanceFromStart - 1200).abs() < 0.1, true);
          expect((position.x - 0).abs() < 0.001, true);
          expect((position.y - (-0)).abs() < 0.001, true);
        },
      );

      test(
        'case 4 (Sagnac interferometer)',
        () {
          final container = ProviderContainer();

          final testOpticsList = <Optics>[
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
            PolarizingBeamSplitter(
              'item6',
              'PBS3',
              OpticsPosition(x: 100, y: 100, z: 0, theta: 45, phi: 90),
            ),
            Mirror(
              'item7',
              'M7',
              OpticsPosition(x: 100, y: 200, z: 0, theta: -90, phi: 90),
            ),
          ];
// nodeのidはintで 0 3 5
          final testOpticsTree = Graph<Optics>(
            {
              Node(
                0.toString(),
                testOpticsList[0],
                // どこと繋がっているか
              ): [
                Node(
                  7.toString(),
                  testOpticsList[4],
                ),
                Node(
                  1.toString(),
                  testOpticsList[1],
                ),
              ],
              Node(
                1.toString(),
                testOpticsList[1],
              ): [
                Node(
                  2.toString(),
                  testOpticsList[2],
                )
              ],
              Node(
                2.toString(),
                testOpticsList[2],
              ): [
                Node(
                  3.toString(),
                  testOpticsList[3],
                ),
              ],
              Node(
                3.toString(),
                testOpticsList[3],
              ): [
                null,
                Node(
                  4.toString(),
                  testOpticsList[4],
                )
              ],
              Node(
                4.toString(),
                testOpticsList[4],
              ): [
                Node(
                  5.toString(),
                  testOpticsList[5],
                ),
              ],
              Node(
                5.toString(),
                testOpticsList[5],
              ): [
                null,
                Node(
                  6.toString(),
                  testOpticsList[6],
                ),
              ],
              Node(
                6.toString(),
                testOpticsList[6],
              ): [],
              Node(
                7.toString(),
                testOpticsList[4],
              ): [
                Node(
                  8.toString(),
                  testOpticsList[3],
                )
              ],
              Node(
                8.toString(),
                testOpticsList[3],
              ): [
                null,
                Node(
                  9.toString(),
                  testOpticsList[2],
                ),
              ],
              Node(
                9.toString(),
                testOpticsList[2],
              ): [
                Node(
                  10.toString(),
                  testOpticsList[1],
                )
              ],
              Node(
                10.toString(),
                testOpticsList[1],
              ): [
                Node(
                  11.toString(),
                  testOpticsList[0],
                )
              ],
              Node(
                11.toString(),
                testOpticsList[0],
              ): [
                null,
                Node(
                  12.toString(),
                  testOpticsList[5],
                )
              ],
              Node(
                12.toString(),
                testOpticsList[5],
              ): [
                null,
                Node(
                  13.toString(),
                  testOpticsList[6],
                ),
              ],
              Node(
                13.toString(),
                testOpticsList[6],
              ): []
            },
          );

          final result =
              container.read(simulationServiceProvider).runSimulation(
                    currentBeam: initialBeam,
                    currentOpticsTree: testOpticsTree,
                  );
          final distanceFromStart_1 =
              result.simulatedBeamList.first.distanceFromStart;
          final distanceFromStart_2 =
              result.simulatedBeamList.first.distanceFromStart;
          final position_1 = result.simulatedBeamList.first.startPositionVector;
          final position_2 = result.simulatedBeamList.last.startPositionVector;
          expect((distanceFromStart_1 - 1800).abs() < 0.01, true);
          expect((distanceFromStart_2 - 1800).abs() < 0.01, true);
          expect((position_1.x - 100).abs() < 0.01, true);
          expect((position_1.y - (200)).abs() < 0.01, true);
          expect((position_2.x - 100).abs() < 0.01, true);
          expect((position_2.y - (200)).abs() < 0.01, true);
        },
      );

      test(
        'case 5',
        () {
          final container = ProviderContainer();

          final testOpticsList = <Optics>[
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
            PolarizingBeamSplitter(
              'item6',
              'PBS3',
              OpticsPosition(x: 100, y: 100, z: 0, theta: 45, phi: 90),
            ),
            Mirror(
              'item7',
              'M7',
              OpticsPosition(x: 100, y: 200, z: 0, theta: -90, phi: 90),
            ),
            Mirror(
              'item8',
              'M8',
              OpticsPosition(x: 300, y: 200, z: 0, theta: -45, phi: 90),
            ),
          ];
// nodeのidはintで 0 3 5
          final testOpticsTree = Graph<Optics>(
            {
              Node(
                0.toString(),
                testOpticsList[0],
                // どこと繋がっているか
              ): [
                Node(
                  7.toString(),
                  testOpticsList[4],
                ),
                Node(
                  1.toString(),
                  testOpticsList[1],
                ),
              ],
              Node(
                1.toString(),
                testOpticsList[1],
              ): [
                Node(
                  2.toString(),
                  testOpticsList[2],
                )
              ],
              Node(
                2.toString(),
                testOpticsList[2],
              ): [
                Node(
                  3.toString(),
                  testOpticsList[3],
                ),
              ],
              Node(
                3.toString(),
                testOpticsList[3],
              ): [
                null,
                Node(
                  4.toString(),
                  testOpticsList[4],
                )
              ],
              Node(
                4.toString(),
                testOpticsList[4],
              ): [
                Node(
                  5.toString(),
                  testOpticsList[5],
                ),
              ],
              Node(
                5.toString(),
                testOpticsList[5],
              ): [
                null,
                Node(
                  6.toString(),
                  testOpticsList[6],
                ),
              ],
              Node(
                6.toString(),
                testOpticsList[6],
              ): [],
              Node(
                7.toString(),
                testOpticsList[4],
              ): [
                Node(
                  8.toString(),
                  testOpticsList[3],
                )
              ],
              Node(
                8.toString(),
                testOpticsList[3],
              ): [
                null,
                Node(
                  9.toString(),
                  testOpticsList[2],
                ),
              ],
              Node(
                9.toString(),
                testOpticsList[2],
              ): [
                Node(
                  10.toString(),
                  testOpticsList[1],
                )
              ],
              Node(
                10.toString(),
                testOpticsList[1],
              ): [
                Node(
                  11.toString(),
                  testOpticsList[0],
                )
              ],
              Node(
                11.toString(),
                testOpticsList[0],
              ): [
                Node(
                  14.toString(),
                  testOpticsList[7],
                ),
                Node(
                  12.toString(),
                  testOpticsList[5],
                )
              ],
              Node(
                12.toString(),
                testOpticsList[5],
              ): [
                null,
                Node(
                  13.toString(),
                  testOpticsList[6],
                ),
              ],
              Node(
                13.toString(),
                testOpticsList[6],
              ): [],
              Node(
                14.toString(),
                testOpticsList[7],
              ): []
            },
          );

          final result =
              container.read(simulationServiceProvider).runSimulation(
                    currentBeam: initialBeam,
                    currentOpticsTree: testOpticsTree,
                  );
          final result_1 = result.simulatedBeamList[0];
          final result_2 = result.simulatedBeamList[1];
          final result_3 = result.simulatedBeamList[2];
          print(
            result.simulatedBeamList
                .map((e) => e.passedOptics.map((o) => o.name).toList())
                .toList(),
          );
          print(
            result.simulatedBeamList.map((e) => e.distanceFromStart).toList(),
          );
          expect((result_1.distanceFromStart - 1600).abs() < 0.01, true);
          expect((result_2.distanceFromStart - 1800).abs() < 0.01, true);
          expect((result_3.distanceFromStart - 1800).abs() < 0.01, true);

          expect((result_1.startPositionVector.x - 300).abs() < 0.01, true);
          expect((result_1.startPositionVector.y - (200)).abs() < 0.01, true);
          expect((result_2.startPositionVector.x - 100).abs() < 0.01, true);
          expect((result_2.startPositionVector.y - (200)).abs() < 0.01, true);
          expect((result_3.startPositionVector.x - 100).abs() < 0.01, true);
          expect((result_3.startPositionVector.y - (200)).abs() < 0.01, true);
          print('end');
        },
      );

      test(
        'case 6 (フォーク型 4股)',
        () {
          final container = ProviderContainer();

          final testBeam = Beam(
            type: 'Gaussian beam',
            waveLength: 800,
            beamWaist: 1,
            startFrom: OpticsPosition(x: 0, y: 0, z: 0, theta: 0, phi: 90),
          );

          final testOpticsList = <Optics>[
            PolarizingBeamSplitter(
              'item1',
              'PBS1',
              OpticsPosition(x: 100, y: 0, z: 0, theta: -135, phi: 90),
            ),
            Mirror(
              'item2',
              'M1',
              OpticsPosition(x: 200, y: 0, z: 0, theta: 135, phi: 90),
            ),
            PolarizingBeamSplitter(
              'item3',
              'PBS2',
              OpticsPosition(x: 200, y: 100, z: 0, theta: -45, phi: 90),
            ),
            Mirror(
              'item4',
              'M2',
              OpticsPosition(x: 200, y: 200, z: 0, theta: -45, phi: 90),
            ),
            Mirror(
              'D1',
              'D1',
              OpticsPosition(x: 300, y: 200, z: 0, theta: 180, phi: 90),
            ),
            Mirror(
              'D2',
              'D2',
              OpticsPosition(x: 300, y: 100, z: 0, theta: 180, phi: 90),
            ),
            Mirror(
              'item5',
              'M3',
              OpticsPosition(x: 100, y: -100, z: 0, theta: 45, phi: 90),
            ),
            PolarizingBeamSplitter(
              'item6',
              'PBS3',
              OpticsPosition(x: 200, y: -100, z: 0, theta: 45, phi: 90),
            ),
            Mirror(
              'D3',
              'D3',
              OpticsPosition(x: 300, y: -100, z: 0, theta: 180, phi: 90),
            ),
            Mirror(
              'item7',
              'M7',
              OpticsPosition(x: 200, y: -200, z: 0, theta: 45, phi: 90),
            ),
            Mirror(
              'D4',
              'D4',
              OpticsPosition(x: 300, y: -200, z: 0, theta: 180, phi: 90),
            ),
          ];
// nodeのidはintで 0 3 5
          final testOpticsTree = Graph<Optics>(
            {
              Node(
                0.toString(),
                testOpticsList[0],
                // どこと繋がっているか
              ): [
                Node(
                  1.toString(),
                  testOpticsList[1],
                ),
                Node(
                  6.toString(),
                  testOpticsList[6],
                )
              ],
              Node(
                1.toString(),
                testOpticsList[1],
              ): [
                Node(
                  2.toString(),
                  testOpticsList[2],
                )
              ],
              Node(
                2.toString(),
                testOpticsList[2],
              ): [
                Node(
                  3.toString(),
                  testOpticsList[3],
                ),
                Node(
                  5.toString(),
                  testOpticsList[5],
                )
              ],
              Node(
                3.toString(),
                testOpticsList[3],
              ): [
                Node(
                  4.toString(),
                  testOpticsList[4],
                )
              ],
              Node(
                4.toString(),
                testOpticsList[4],
              ): [],
              Node(
                5.toString(),
                testOpticsList[5],
              ): [],
              Node(
                6.toString(),
                testOpticsList[6],
              ): [
                Node(
                  7.toString(),
                  testOpticsList[7],
                )
              ],
              Node(
                7.toString(),
                testOpticsList[7],
              ): [
                Node(
                  8.toString(),
                  testOpticsList[8],
                ),
                Node(
                  9.toString(),
                  testOpticsList[9],
                )
              ],
              Node(
                8.toString(),
                testOpticsList[8],
              ): [],
              Node(
                9.toString(),
                testOpticsList[9],
              ): [
                Node(
                  10.toString(),
                  testOpticsList[10],
                )
              ],
              Node(
                10.toString(),
                testOpticsList[10],
              ): [],
            },
          );

          final result =
              container.read(simulationServiceProvider).runSimulation(
                    currentBeam: testBeam,
                    currentOpticsTree: testOpticsTree,
                  );
          final result_1 = result.simulatedBeamList[0];
          final result_2 = result.simulatedBeamList[1];
          final result_3 = result.simulatedBeamList[2];
          final result_4 = result.simulatedBeamList[3];

          print(
            result.simulatedBeamList
                .map((e) => e.passedOptics.map((o) => o.name).toList())
                .toList(),
          );
          print(
            result.simulatedBeamList.map((e) => e.distanceFromStart).toList(),
          );
          expect((result_1.distanceFromStart - 500).abs() < 0.01, true);
          expect((result_2.distanceFromStart - 400).abs() < 0.01, true);
          expect((result_3.distanceFromStart - 400).abs() < 0.01, true);
          expect((result_4.distanceFromStart - 500).abs() < 0.01, true);

          expect((result_1.startPositionVector.x - 300).abs() < 0.01, true);
          expect((result_1.startPositionVector.y - (200)).abs() < 0.01, true);
          expect((result_2.startPositionVector.x - 300).abs() < 0.01, true);
          expect((result_2.startPositionVector.y - (100)).abs() < 0.01, true);
          expect((result_3.startPositionVector.x - 300).abs() < 0.01, true);
          expect((result_3.startPositionVector.y - (-100)).abs() < 0.01, true);
          expect((result_4.startPositionVector.x - 300).abs() < 0.01, true);
          expect((result_4.startPositionVector.y - (-200)).abs() < 0.01, true);
          print('end');
        },
      );
    },
  );
}
