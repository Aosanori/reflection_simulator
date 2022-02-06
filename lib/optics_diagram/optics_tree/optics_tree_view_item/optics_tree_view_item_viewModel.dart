import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../common/view_model_change_notifier.dart';
import '../../../simulation/optics_state.dart';
import '../../../simulation/simulation_repository.dart';
import '../../../utils/graph.dart';
import '../../../utils/random_string.dart';

import '../../optics.dart';



final opticsTreeItemViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<OpticsTreeItemViewModel, Node>(
  (ref, opticsNode) => OpticsTreeItemViewModel(
    ref.watch(simulationRepositoryProvider),
    ref.watch(opticsStateActionProvider),
    opticsNode,
  ),
);

class OpticsTreeItemViewModel extends ViewModelChangeNotifier {
  OpticsTreeItemViewModel(
    this._simulationRepository,
    this._opticsStateAction,
    this.opticsNode,
  );
  final SimulationRepository _simulationRepository;
  final OpticsStateAction _opticsStateAction;
  final Node opticsNode;

  List<Optics> get currentOpticsList => _simulationRepository.currentOpticsList;
  Graph get currentOpticsTree => _simulationRepository.currentOpticsTree;

  late Optics connectTo = _simulationRepository.currentOpticsList.first;

  late bool willReflect = true;

  String? currentAction;

  List<String> get action {
    const actions = ['Reflect', 'Transparent'];
    if (opticsNode.data.runtimeType == Mirror) {
      return ['Reflect'];
    }

    if (opticsNode.data.runtimeType == PolarizingBeamSplitter) {
      final res = <String>[];
      // 透過がない場合
      if (currentOpticsTree.nodes[opticsNode]?[0] == null) {
        res.add(actions[1]);
      }

      //反射がない場合
      if (currentOpticsTree.nodes[opticsNode]?[1] == null) {
        res.add(actions[0]);
      }
      return res;
    }
    return [''];
  }

  void changeAction(String? newAction) {
    if (newAction == 'Reflect') {
      willReflect = true;
      currentAction = 'Reflect';
    }

    if (newAction == 'Transparent') {
      willReflect = false;
      currentAction = 'Transparent';
    }
    notifyListeners();
  }

  void changeConnectTo(Optics? optics) {
    connectTo = optics!;
    notifyListeners();
  }

  void createRelation() {
    final currentOpticsTree = _simulationRepository.currentOpticsTree;
    final newNode = Node(randomString(4), connectTo);
    _opticsStateAction.addNode(newNode, opticsNode, willReflect);
    notifyListeners();
  }

  void deleteNode() {
    _opticsStateAction.deleteNode(opticsNode);
    notifyListeners();
  }
}
