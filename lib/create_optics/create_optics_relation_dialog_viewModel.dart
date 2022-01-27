import 'package:hooks_riverpod/hooks_riverpod.dart';

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

  late Node connectFrom =
      _simulationRepository.currentOpticsTree.nodes.keys.first;

  late Optics connectTo = _simulationRepository.currentOpticsList.first;

  List<Optics> get currentOpticsList => _simulationRepository.currentOpticsList;

  List<Node> get currentOpticsTree =>
      _simulationRepository.currentOpticsTree.nodes.keys.map((e) => e).toList();

  // Listから選ばせればいい
  void createRelation() {
    // TODO: create
    final currentOpticsTree = _simulationRepository.currentOpticsTree;
    final newNode = Node(currentOpticsTree.nodes.length, connectTo);
    _opticsStateAction.addNode(newNode, connectFrom);
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
