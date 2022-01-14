import 'dart:math';

import 'package:complex/complex.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/view_model_change_notifier.dart';
import '../../simulation/simulation_service.dart';
import '../../utils/environments_variables.dart';
import '../optics.dart';

final opticsDiagramItemViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<OpticsDiagramItemViewModel, int>(
  (ref, index) =>
      OpticsDiagramItemViewModel(ref.watch(simulationServiceProvider), index),
);

class OpticsDiagramItemViewModel extends ViewModelChangeNotifier {
  OpticsDiagramItemViewModel(this._simulationService, this.index) {
    final opticsList = _simulationService.currentOpticsList;
    _optics = opticsList[index];
    if (_simulationService.currentOpticsList.isNotEmpty &&
        index < _simulationService.currentOpticsList.length - 1) {
      final nextOptics = _simulationService.currentOpticsList[index + 1];

      // 前の進行方向逆の偏角
      final currentBeamStartPosition =
          _simulationService.currentBeam.startFrom.vector;
      final vectorOfPreviousDirection = index != 0
          ? opticsList[index - 1].position.vector -
              opticsList[index].position.vector
          : currentBeamStartPosition - opticsList[index].position.vector;
      final directionToPreviousOptics =
          Complex(vectorOfPreviousDirection.x, vectorOfPreviousDirection.y);

      // 次の進行方向の偏角
      final vectorOfNextDirection =
          nextOptics.position.vector - _optics.position.vector;
      final directionToNextOptics =
          Complex(vectorOfNextDirection.x, vectorOfNextDirection.y);

      // 確実に当たる角度
      final idealTheta = (directionToNextOptics / directionToNextOptics.abs() +
                  directionToPreviousOptics / directionToPreviousOptics.abs())
              .argument() *
          180 /
          pi;

      rangeOfTheta = [
        idealTheta - adjustableAngleOfMirror,
        idealTheta + adjustableAngleOfMirror
      ];
    } else {
      rangeOfTheta = [-180, 180];
    }
  }
  final int index;
  final SimulationService _simulationService;

  late Optics _optics;
  late List<double> rangeOfTheta;

  Optics get optics => _optics;

  void changeTheta(int index, double value) {
    _optics.position.theta = value;
    notifyListeners();
    _simulationService.runSimulation();
  }

  void changePhi(int index, double value) {
    _optics.position.phi = value;
    notifyListeners();
    _simulationService.runSimulation();
  }
}
