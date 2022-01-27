import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphview/GraphView.dart' as gv;
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      ..subtreeSeparation = (100)
      ..orientation = 1;
    return graph;
  }

  Optics getOpticsFromGraph(int nodeID) {
    final index =
        currentOpticsTree.nodes.keys.map((e) => e.id).toList().indexOf(nodeID);
    return currentOpticsTree.nodes.keys.elementAt(index).data;
  }
}
