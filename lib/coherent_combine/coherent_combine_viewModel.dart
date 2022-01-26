import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:vector_math/vector_math.dart';

import '../../common/view_model_change_notifier.dart';
import '../../simulation/simulation_state_store_service.dart';
import '../beam_information/beam.dart';
import '../simulation/simulation_with_changing_value.dart';
import '../utils/environments_variables.dart';

final coherentCombineViewModelProvider = ChangeNotifierProvider(
  (ref) => CoherentCombineViewModel(
    ref.watch(simulationStateStoreProvider),
    ref.watch(simulationWithChangingValueProvider),
  ),
);

class CoherentCombineViewModel extends ViewModelChangeNotifier {
  CoherentCombineViewModel(
    this._simulationStateStore,
    this._simulationWithChangingValue,
  ) {
    _simulationWithChangingValue.runSimulation(
      target: initialOpticsList[2],
      targetValue: 'theta',
    );
  }

  final SimulationStateStore _simulationStateStore;
  final SimulationWithChangingValue _simulationWithChangingValue;

  List<double> get distanceFromStartList =>
      _simulationStateStore.state.simulationResult.simulatedBeamList
          .map((beam) => beam.distanceFromStart)
          .toList();

  List<double> get angles {
    final beams =
        _simulationStateStore.state.simulationResult.simulatedBeamList;
    final results = beams.map((beam) {
      final angle =
          beam.direction.angleTo(beam.passedOptics.last.normalVector) *
              180 /
              pi;
      //if(beam.direction-)
      return angle;
    }).toList();
    return results;
  }

  List<GaugePointer> get gaugePointer {
    final result = <GaugePointer>[];
    var index = 0;
    for (final angle in angles) {
      result.add(
        NeedlePointer(
          value: angle,
          needleEndWidth: 5,
          needleColor: branchColor[index],
          knobStyle: KnobStyle(
            knobRadius: 0,
            sizeUnit: GaugeSizeUnit.logicalPixel,
            color: branchColor[index],
          ),
        ),
      );
      index++;
    }
    return result;
    /*angles.map<GaugePointer>((e) {
      NeedlePointer(
        value: e,
        needleEndWidth: 5,
        knobStyle: KnobStyle(
          knobRadius: 0,
          sizeUnit: GaugeSizeUnit.logicalPixel,
          color: branchColor[index],
        ),
      );
    }).toList();*/
  }

  double get idealDistanceFromEnd {
    var result = 0.0;
    final positionList = _simulationStateStore
        .state.simulationResult.simulatedBeamList.first.passedOptics
        .map((optics) => optics.position.vector)
        .toList();

    var previousPosition =
        _simulationStateStore.state.currentBeam.startFrom.vector;
    for (final position in positionList) {
      result += previousPosition.distanceTo(position);
      previousPosition = position;
    }
    return result;
  }

  List<LinearBarPointer> get barPointers {
    final result = <LinearBarPointer>[];
    var offset = 0.0;
    var index = 0;
    for (final beam
        in _simulationStateStore.state.simulationResult.simulatedBeamList) {
      result.add(
        LinearBarPointer(
          value: beam.distanceFromStart,
          offset: offset,
          position: LinearElementPosition.outside,
          color: branchColor[index],
        ),
      );
      offset += 10;
      index++;
    }
    return result;
  }

  double get averageDistanceFromStart {
    var result = 0.0;
    for (final beam
        in _simulationStateStore.state.simulationResult.simulatedBeamList) {
      result += beam.distanceFromStart;
    }
    return result /
        _simulationStateStore.state.simulationResult.simulatedBeamList.length
            .toDouble();
  }

  List<int> get lastOpticsNodeIdList {
    final reflectionPositions =
        _simulationStateStore.state.simulationResult.reflectionPositions;
    // O(N)
    return reflectionPositions.map((branch) => branch.last.keys.first).toList();
  }

  bool get isCombined {
    var result = true;
    var previousOptics = _simulationStateStore
        .state.currentOpticsTree.nodes.keys
        .elementAt(lastOpticsNodeIdList.first)
        .data;
    for (var i = 1; i < lastOpticsNodeIdList.length; i++) {
      final nodeID = lastOpticsNodeIdList[i];
      final optics = _simulationStateStore.state.currentOpticsTree.nodes.keys
          .elementAt(nodeID)
          .data;
      result &= optics == previousOptics;
      previousOptics = optics;
    }
    return result;
  }

  double get combineRate {
    final reflectionPositions =
        _simulationStateStore.state.simulationResult.reflectionPositions;
    final resultsOfEnd =
        reflectionPositions.map((branch) => branch.last.values.first).toList();
    final beams =
        _simulationStateStore.state.simulationResult.simulatedBeamList;

    final data = <Beam, Vector3>{};
    for (var i = 0; i < resultsOfEnd.length; i++) {
      data[beams[i]] = resultsOfEnd[i];
    }

    return monteCarlo(data);
  }

  // TODO:　全方向に対応
  double circles_intersection_area(Vector3 p1, num r1, Vector3 p2, num r2) {
    final x1 = p1.x;
    final y1 = p1.z;
    final x2 = p2.x;
    final y2 = p2.z;

    final dd = (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);

    if ((r1 + r2) * (r1 + r2) <= dd) {
      return 0.0;
    }

    if (dd <= (r1 - r2) * (r1 - r2)) {
      return pi * min(r1, r2) * min(r1, r2);
    }

    final p_1 = r1 * r1 - r2 * r2 + dd;
    final p_2 = r2 * r2 - r1 * r1 + dd;

    final s1 = r1 * r1 * atan2(sqrt(4 * dd * r1 * r1 - p_1 * p_1), p_1);
    final s2 = r2 * r2 * atan2(sqrt(4 * dd * r2 * r2 - p_2 * p_2), p_2);
    final s0 = sqrt(4 * dd * r1 * r1 - p_1 * p_1) / 2;

    return s1 + s2 - s0;
  }

  double monteCarlo(Map<Beam, Vector3> data) {
    /*final center = data.keys.first.passedOptics.last.position.vector;
    final positions = data.values;
    const total = 10000;
    var count = 0;
    while (count < total) {
      final x = Random().nextDouble() * 2 - 1;
      final y = Random().nextDouble() * 2 - 1;
      var valid = true;
      if(){
        count++;
      }
      
    }
    return (count / total) * 100;*/
    if (data.keys.length == 2) {
      final p1 = data.values.elementAt(0);
      final p2 = data.values.elementAt(1);
      final r1 = data.keys.elementAt(0).beamWaist;
      final r2 = data.keys.elementAt(1).beamWaist;
      return circles_intersection_area(p1, r1, p2, r2) /
          (min(r1, r2) * min(r1, r2) * pi) *
          100;
    }
    return 0;
  }
}
