import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphview/GraphView.dart' as gv;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/view_model_change_notifier.dart';
import '../../simulation/optics_state.dart';
import '../../simulation/simulation_repository.dart';
import '../../utils/graph.dart';
import '../../utils/random_string.dart';
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

    currentOpticsTree.nodes.forEach(
      (key, value) {
        final rootNode = gv.Node.Id(key.id);
        if (graph.nodes.isEmpty) {
          graph.addNode(rootNode);
        }
        for (final edge in value) {
          if (edge != null) {
            final edgeNode = gv.Node.Id(edge.id);
            graph.addEdge(
              rootNode,
              edgeNode,
              paint: Paint()..color = Colors.black,
            );
          }
        }
      },
    );

    builder
      ..siblingSeparation = (100)
      ..levelSeparation = (50)
      ..subtreeSeparation = (75)
      ..orientation = 1;
    return graph;
  }

  Node getOpticsNodeFromGraph(String nodeID) {
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
