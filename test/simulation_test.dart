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
          final targetValue = 'theta';
          final container = ProviderContainer();
          final repository = container.read(simulationRepositoryProvider);
          final results = repository.runSimulationWithChangingValue(
            VariableOfSimulationWithChangingValue(
              targetOptics,
              targetValue,
              margin: 0.005,
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
          final targetValue = 'theta';
          final container = ProviderContainer();
          final repository = container.read(simulationRepositoryProvider);
          final com = await compute(
            repository.runSimulationWithChangingValue,
            VariableOfSimulationWithChangingValue(
              targetOptics,
              targetValue,
              margin: 0.005,
            ),
          );
          stopwatch.stop();
          expect(stopwatch.elapsed.inMilliseconds < 150, true);
        },
      );
      test(
        'initial value',
        () {
          final container = ProviderContainer();
          final result =
              container.read(simulationServiceProvider).runSimulation(
                    currentBeam: initialBeam,
                    currentOpticsTree: initialOpticsTree,
                  );

          final distanceFromStart =
              result.simulatedBeamList.first.distanceFromStart;
          expect((distanceFromStart - 1800).abs() < 1, true);
        },
      );
      test(
        'case 1 (直角反射)',
        () {
          final container = ProviderContainer();
          final testTree = Graph<Optics>(
            {
              Node(
                0,
                Mirror(
                  'item1',
                  'M1',
                  OpticsPosition(x: 300, y: 100, z: 0, theta: -135, phi: 90),
                ),
                // どこと繋がっているか
              ): [
                Node(
                  1,
                  Mirror(
                    'item2',
                    'M2',
                    OpticsPosition(x: 300, y: -100, z: 0, theta: 45, phi: 90),
                  ),
                ),
              ],
              Node(
                1,
                Mirror(
                  'item2',
                  'M2',
                  OpticsPosition(x: 300, y: -100, z: 0, theta: 45, phi: 90),
                ),
              ): [
                Node(
                  2,
                  Mirror(
                    'item3',
                    'M3',
                    OpticsPosition(x: 500, y: -100, z: 0, theta: 180, phi: 90),
                  ),
                )
              ],
              Node(
                2,
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
                0,
                Mirror(
                  'item1',
                  'M1',
                  OpticsPosition(x: 300, y: 0, z: 0, theta: -180, phi: 90),
                ),
                // どこと繋がっているか
              ): [
                Node(
                  1,
                  Mirror(
                    'item2',
                    'M2',
                    OpticsPosition(x: -300, y: 0, z: 0, theta: 0, phi: 90),
                  ),
                ),
              ],
              Node(
                1,
                Mirror(
                  'item2',
                  'M2',
                  OpticsPosition(x: -300, y: 0, z: 0, theta: 0, phi: 90),
                ),
              ): [
                Node(
                  2,
                  Mirror(
                    'item3',
                    'M3',
                    OpticsPosition(x: 0, y: -0, z: 0, theta: 180, phi: 90),
                  ),
                )
              ],
              Node(
                2,
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
                0,
                Mirror(
                  'item1',
                  'M1',
                  OpticsPosition(x: 100, y: 0, z: 0, theta: 120, phi: 90),
                ),
                // どこと繋がっているか
              ): [
                Node(
                  1,
                  Mirror(
                    'item2',
                    'M2',
                    OpticsPosition(x: 200, y: 173.2, z: 0, theta: 180, phi: 90),
                  ),
                ),
              ],
              Node(
                1,
                Mirror(
                  'item2',
                  'M2',
                  OpticsPosition(x: 200, y: 173.2, z: 0, theta: 180, phi: 90),
                ),
              ): [
                Node(
                  2,
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
                2,
                Mirror(
                  'item3',
                  'M3',
                  OpticsPosition(x: 100, y: 346.4, z: 0, theta: -120, phi: 90),
                ),
              ): [
                Node(
                  3,
                  Mirror(
                    'item4',
                    'M4',
                    OpticsPosition(
                        x: -100, y: 346.4, z: 0, theta: -60, phi: 90),
                  ),
                ),
              ],
              Node(
                3,
                Mirror(
                  'item4',
                  'M4',
                  OpticsPosition(x: -100, y: 346.4, z: 0, theta: -60, phi: 90),
                ),
              ): [
                Node(
                  4,
                  Mirror(
                    'item5',
                    'M5',
                    OpticsPosition(x: -200, y: 173.2, z: 0, theta: 0, phi: 90),
                  ),
                ),
              ],
              Node(
                4,
                Mirror(
                  'item5',
                  'M5',
                  OpticsPosition(x: -200, y: 173.2, z: 0, theta: 0, phi: 90),
                ),
              ): [
                Node(
                  5,
                  Mirror(
                    'item6',
                    'M6',
                    OpticsPosition(x: -100, y: 0, z: 0, theta: 60, phi: 90),
                  ),
                )
              ],
              Node(
                5,
                Mirror(
                  'item6',
                  'M6',
                  OpticsPosition(x: -100, y: 0, z: 0, theta: 60, phi: 90),
                ),
              ): [
                Node(
                  6,
                  Mirror(
                    'item7',
                    'M7',
                    OpticsPosition(x: 0, y: -0, z: 0, theta: 180, phi: 90),
                  ),
                )
              ],
              Node(
                6,
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
    },
  );
}
