import 'dart:math';

import 'package:complex/complex.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/view_model_change_notifier.dart';
import '../../simulation/optics_state.dart';
import '../../simulation/simulation_repository.dart';
import '../../utils/environments_variables.dart';
import '../optics.dart';

final opticsDiagramItemViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<OpticsDiagramItemViewModel, int>(
  (ref, index) => OpticsDiagramItemViewModel(
    ref.watch(simulationRepositoryProvider),
    ref.watch(opticsStateActionProvider),
    index,
  ),
);

class OpticsDiagramItemViewModel extends ViewModelChangeNotifier {
  OpticsDiagramItemViewModel(
      this._simulationRepository, this._opticsStateAction, this.index) {
    final opticsList = _simulationRepository
        .simulationResult.simulatedBeamList.first.passedOptics;
    
    if (index >= opticsList.length) {
      rangeOfTheta = [-180, 180];
      _optics = _simulationRepository.currentOpticsList[index];
      return;
    }

    _optics = opticsList[index];
    // 確実に当たる角度をスライダーの中心にする
    if (_simulationRepository.currentOpticsList.isNotEmpty &&
        index < _simulationRepository.currentOpticsList.length - 1) {
      final nextOptics = _simulationRepository.currentOpticsList[index + 1];

      // 前の進行方向逆の偏角
      final currentBeamStartPosition =
          _simulationRepository.currentBeam.startFrom.vector;
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

      final minimumValueOfTheta = idealTheta - adjustableAngleOfMirror;
      final maximumValueOfTheta = idealTheta + adjustableAngleOfMirror;
      rangeOfTheta = [
        minimumValueOfTheta,
        maximumValueOfTheta,
      ];

      // 調整時に範囲から出ていたらやり直す
      if (!(minimumValueOfTheta <= _optics.position.theta &&
          _optics.position.theta <= maximumValueOfTheta)) {
        _optics.position.theta =
            (minimumValueOfTheta + maximumValueOfTheta) / 2;
        _opticsStateAction.editOptics(_optics);
      }
    } else {
      rangeOfTheta = [-180, 180];
    }
  }

  final int index;
  final SimulationRepository _simulationRepository;
  final OpticsStateAction _opticsStateAction;

  late Optics _optics;
  late List<double> rangeOfTheta;

  Optics get optics => _optics.copy();

  void changeTheta(int index, double value) {
    _optics.position.theta = value;
    _opticsStateAction.editOptics(_optics);
    notifyListeners();
  }

  void changePhi(int index, double value) {
    _optics.position.phi = value;
    _opticsStateAction.editOptics(_optics);
    notifyListeners();
  }
}
