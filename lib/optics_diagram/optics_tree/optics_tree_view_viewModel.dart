import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphview/GraphView.dart' as gv;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reflection_simulator/simulation/optics_state.dart';

import '../../common/view_model_change_notifier.dart';
import '../../simulation/simulation_repository.dart';
import '../../utils/graph.dart';
import '../optics.dart';

final opticsTreeViewViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => OpticsTreeViewViewModel(
    ref.watch(simulationRepositoryProvider),
  ),
);

class OpticsTreeViewViewModel extends ViewModelChangeNotifier {
  OpticsTreeViewViewModel(this._simulationRepository);
  final SimulationRepository _simulationRepository;
  Graph get currentOpticsTree => _simulationRepository.currentOpticsTree;

  late gv.BuchheimWalkerConfiguration builder =
      gv.BuchheimWalkerConfiguration();

  gv.Graph get graph {
    final graph = gv.Graph()..isTree = true;

    currentOpticsTree.nodes.forEach((key, value) {
      final rootNode = gv.Node.Id(key.id);
      for (final edge in value) {
        final edgeNode = gv.Node.Id(edge.id);
        graph.addEdge(rootNode, edgeNode, paint: Paint()..color = Colors.black);
      }
    });

    builder
      ..siblingSeparation = (100)
      ..levelSeparation = (50)
      ..subtreeSeparation = (75)
      ..orientation = 1;
    return graph;
  }

  Node getOpticsNodeFromGraph(int nodeID) {
    final index =
        currentOpticsTree.nodes.keys.map((e) => e.id).toList().indexOf(nodeID);
    return currentOpticsTree.nodes.keys.elementAt(index);
  }
}

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

  void changeConnectTo(Optics? optics) {
    connectTo = optics!;
    notifyListeners();
  }

  void createRelation() {
    final currentOpticsTree = _simulationRepository.currentOpticsTree;
    final newNode = Node(currentOpticsTree.nodes.length, connectTo);
    _opticsStateAction.addNode(newNode, opticsNode);
    notifyListeners();
  }
}
