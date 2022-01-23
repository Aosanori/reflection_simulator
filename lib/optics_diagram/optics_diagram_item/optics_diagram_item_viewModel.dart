import 'dart:math';

import 'package:complex/complex.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/view_model_change_notifier.dart';
import '../../simulation/optics_state.dart';
import '../../simulation/simulation_state_store_service.dart';
import '../../utils/environments_variables.dart';
import '../optics.dart';

final opticsDiagramItemViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<OpticsDiagramItemViewModel, int>(
  (ref, index) => OpticsDiagramItemViewModel(
      ref.watch(simulationStateStoreProvider),
      ref.watch(opticsStateProvider),
      index,),
);

class OpticsDiagramItemViewModel extends ViewModelChangeNotifier {
  OpticsDiagramItemViewModel(
      this._simulationStateStore, this._opticsState, this.index) {
    final opticsList = _simulationStateStore.state.currentOpticsList;
    _optics = opticsList[index];
    // 確実に当たる角度をスライダーの中心にする
    if (_simulationStateStore.state.currentOpticsList.isNotEmpty &&
        index < _simulationStateStore.state.currentOpticsList.length - 1) {
      final nextOptics =
          _simulationStateStore.state.currentOpticsList[index + 1];

      // 前の進行方向逆の偏角
      final currentBeamStartPosition =
          _simulationStateStore.state.currentBeam.startFrom.vector;
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
        _opticsState.editOptics(_optics);
      }
    } else {
      rangeOfTheta = [-180, 180];
    }
  }

  final int index;
  final SimulationStateStore _simulationStateStore;
  final OpticsState _opticsState;

  late Optics _optics;
  late List<double> rangeOfTheta;

  Optics get optics => _optics;

  void changeTheta(int index, double value) {
    _optics.position.theta = value;
    notifyListeners();
    _opticsState.editOptics(_optics);
  }

  void changePhi(int index, double value) {
    _optics.position.phi = value;
    notifyListeners();
    _opticsState.editOptics(_optics);
  }
}
