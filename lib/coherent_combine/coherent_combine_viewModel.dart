import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:vector_math/vector_math.dart';

import '../../common/view_model_change_notifier.dart';
import '../beam_information/beam.dart';
import '../csv/csv_service.dart';
import '../optics_diagram/optics.dart';
import '../simulation/simulation_repository.dart';
import '../utils/environments_variables.dart';

class ChartData {
  ChartData(this.x, this.y);
  final double x;
  final double y;

  List<String> toCsvFormat() => [
        '$x',
        '$y',
      ];
}

final _changeOpticsValueChartViewModelProvider = ChangeNotifierProvider(
  (ref) => ChangeOpticsValueChartViewModel(),
);

class ChangeOpticsValueChartViewModel extends ViewModelChangeNotifier {
  ChangeOpticsValueChartViewModel() {
    targetOptics = null;
    targetValue = null;
  }

  late Optics? targetOptics;
  late String? targetValue;

  void initialize(Optics optics, String value) {
    targetOptics = optics;
    targetValue = value;
    notifyListeners();
  }

  void setOptics(Optics optics) {
    targetOptics = optics;
    notifyListeners();
  }

  void setTargetValue(String value) {
    targetValue = value;
    notifyListeners();
  }
}

final coherentCombineViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => CoherentCombineViewModel(
    ref.watch(simulationRepositoryProvider),
    ref.watch(_changeOpticsValueChartViewModelProvider),
    ref.watch(
      csvServiceProvider,
    ),
  ),
);

class CoherentCombineViewModel extends ViewModelChangeNotifier {
  CoherentCombineViewModel(this._simulationRepository,
      this._changeOpticsValueChartViewModel, this._csvService,) {
    if (_changeOpticsValueChartViewModel.targetOptics == null ||
        _changeOpticsValueChartViewModel.targetValue == null) {
      _changeOpticsValueChartViewModel.initialize(initialOpticsList[1], 'theta');
    }
    targetOptics = _changeOpticsValueChartViewModel.targetOptics!;
    targetValue = _changeOpticsValueChartViewModel.targetValue!;
  }

  final SimulationRepository _simulationRepository;
  final ChangeOpticsValueChartViewModel _changeOpticsValueChartViewModel;
  final CSVService _csvService;

  final List<String> targetValues = [
    'x',
    'y',
    'z',
    'theta',
    'phi',
    'x-y Diagonal'
  ];

  late Optics targetOptics;
  late String targetValue;

  void changeTargetOptics(String? target) {
    final index = _simulationRepository.currentOpticsList
        .map((e) => e.name)
        .toList()
        .indexOf(target!);
    targetOptics = _simulationRepository.currentOpticsList[index];
    _changeOpticsValueChartViewModel.setOptics(targetOptics);
    notifyListeners();
  }

  void changeTargetValue(String? value) {
    targetValue = value!;
    _changeOpticsValueChartViewModel.setTargetValue(targetValue);
    notifyListeners();
  }

  void downloadCSV() {
    _csvService.csvDownload(
      header: [targetValue + ' of ' + targetOptics.name, 'CombineRate'],
      chartData: chartData,
    );
  }

  List<String> get opticsNameList =>
      _simulationRepository.currentOpticsList.map((e) => e.name).toList();

  List<ChartData> get chartData {
    final results = _simulationRepository.runSimulationWithChangingValue(
      VariableOfSimulationWithChangingValue(targetOptics, targetValue),
    );
    /*final results = await compute(
      _simulationRepository.runSimulationWithChangingValue,
      VariableOfSimulationWithChangingValue(targetOptics,targetValue),
    );*/

    final chartData = <ChartData>[];

    results.forEach((key, value) {
      final reflectionPositions = value.reflectionPositions;
      final resultsOfEnd = reflectionPositions
          .map((branch) => branch.last.values.first)
          .toList();
      final beams = value.simulatedBeamList;
      final data = <Beam, Vector3>{};
      for (var i = 0; i < resultsOfEnd.length; i++) {
        data[beams[i]] = resultsOfEnd[i];
      }
      final result = monteCarlo(data);

      bool isOffMirror = false;
      data.forEach((key, value) {
        if (Vector3(100, 200, 0).distanceTo(value) >= 12.7) {
          isOffMirror = true;
        }
      });
      if (isOffMirror) {
        chartData.add(ChartData(key, 0));
      } else {
        chartData.add(ChartData(key, result));
      }
    });
    print('Max ${chartData.map((e) => e.y).toList().reduce(max)} %');
    return chartData;
  }

  List<double> get distanceFromStartList =>
      _simulationRepository.simulationResult.simulatedBeamList
          .map((beam) => beam.distanceFromStart)
          .toList();

  List<double> get angles {
    final beams = _simulationRepository.simulationResult.simulatedBeamList;
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
  }

  double get idealDistanceFromEnd {
    var result = 0.0;
    final positionList = _simulationRepository
        .simulationResult.simulatedBeamList.first.passedOptics
        .map((optics) => optics.position.vector)
        .toList();

    var previousPosition = _simulationRepository.currentBeam.startFrom.vector;
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
        in _simulationRepository.simulationResult.simulatedBeamList) {
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
        in _simulationRepository.simulationResult.simulatedBeamList) {
      result += beam.distanceFromStart;
    }
    return result /
        _simulationRepository.simulationResult.simulatedBeamList.length
            .toDouble();
  }

  List<String> get lastOpticsNodeIdList {
    final reflectionPositions =
        _simulationRepository.simulationResult.reflectionPositions;
    // O(N)
    return reflectionPositions.map((branch) => branch.last.keys.first).toList();
  }

  bool get isCombined {
    var result = true;
    var previousOptics = _simulationRepository.currentOpticsTree.opticsWithNodeID[lastOpticsNodeIdList.first];
    for (var i = 1; i < lastOpticsNodeIdList.length; i++) {
      final nodeID = lastOpticsNodeIdList[i];
      final optics = _simulationRepository
          .currentOpticsTree.opticsWithNodeID[nodeID];
      result &= optics == previousOptics;
      previousOptics = optics;
    }
    return result;
  }

  double get combineRate {
    final reflectionPositions =
        _simulationRepository.simulationResult.reflectionPositions;
    final resultsOfEnd =
        reflectionPositions.map((branch) => branch.last.values.first).toList();
    final beams = _simulationRepository.simulationResult.simulatedBeamList;

    final data = <Beam, Vector3>{};
    for (var i = 0; i < resultsOfEnd.length; i++) {
      data[beams[i]] = resultsOfEnd[i];
    }

    return monteCarlo(data);
  }

  // TODO:　全方向に対応
  double circlesIntersectionArea(Vector3 p1, num r1, Vector3 p2, num r2) {
    final x1 = p1.x;
    final y1 = p1.z;
    final x2 = p2.x;
    final y2 = p2.z;

    final dd = (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);

    if ((r1 + r2) * (r1 + r2) <= dd) {
      return 0;
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
      return circlesIntersectionArea(p1, r1, p2, r2) /
          (min(r1, r2) * min(r1, r2) * pi) *
          100;
    }
    return 0;
  }
}
