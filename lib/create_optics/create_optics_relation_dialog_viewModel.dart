import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reflection_simulator/utils/random_string.dart';

import '../../common/view_model_change_notifier.dart';
import '../optics_diagram/optics.dart';
import '../simulation/optics_state.dart';
import '../simulation/simulation_repository.dart';
import '../utils/graph.dart';

final createOpticsRelationDialogViewModelProvider =
    ChangeNotifierProvider.autoDispose(
  (ref) => CreateOpticsRelationDialogViewModel(
    ref.watch(simulationRepositoryProvider),
    ref.watch(opticsStateActionProvider),
  ),
);

class CreateOpticsRelationDialogViewModel extends ViewModelChangeNotifier {
  CreateOpticsRelationDialogViewModel(
    this._simulationRepository,
    this._opticsStateAction,
  );
  final SimulationRepository _simulationRepository;
  final OpticsStateAction _opticsStateAction;

  late Node connectFrom = currentOpticsTree.first;

  late Optics connectTo = _simulationRepository.currentOpticsList.first;

  List<Optics> get currentOpticsList => _simulationRepository.currentOpticsList;

  List<Node> get currentOpticsTree {
    final ableToConnect = <Node>[];
    _simulationRepository.currentOpticsTree.nodes.forEach((key, value) {
      if (key.data.runtimeType == Mirror && value.isEmpty) {
        ableToConnect.add(key);
      }

      if (key.data.runtimeType == PolarizingBeamSplitter && value.length < 2) {
        ableToConnect.add(key);
      }
    });
    return ableToConnect;
    //.keys.map((e) => e).toList();
  }

  // Listから選ばせればいい
  void createRelation() {
    final currentOpticsTree = _simulationRepository.currentOpticsTree;
    final newNode = Node(randomString(4), connectTo);
    //_opticsStateAction.addNode(newNode, connectFrom);
    notifyListeners();
  }

  void changeConnectFrom(Node? node) {
    connectFrom = node!;
    notifyListeners();
  }

  void changeConnectTo(Optics? optics) {
    connectTo = optics!;
    notifyListeners();
  }
}
