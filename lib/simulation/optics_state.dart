import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../beam_information/beam.dart';
import '../common/view_model_change_notifier.dart';
import '../optics_diagram/optics.dart';
import '../utils/environments_variables.dart';
import '../utils/graph.dart';

final opticsStateActionProvider =
    Provider((ref) => OpticsStateAction(ref.watch(opticsStateProvider)));

class OpticsStateAction {
  OpticsStateAction(this._opticsState);
  final OpticsState _opticsState;

  void addNode(Node node, Node previousNode, bool willReflect) {
    _opticsState.addNode(node, previousNode, willReflect);
  }

  void deleteNode(Node node) {
    _opticsState.deleteNode(node);
  }

  void addOptics(Optics optics) {
    _opticsState.addOptics(optics);
  }

  void deleteOptics(Optics optics) {
    _opticsState.deleteOptics(optics);
  }

  void editOptics(Optics optics) {
    _opticsState.editOptics(optics);
  }

  void editBeam(Beam newBeam) {
    _opticsState.editBeam(newBeam);
  }
}

final opticsStateProvider = ChangeNotifierProvider(
  (ref) => OpticsState(),
);

class OpticsState extends ViewModelChangeNotifier {
  OpticsState() {
    currentOpticsList = initialOpticsList;
    currentOpticsTree = initialOpticsTree;
    currentBeam = initialBeam;

    for (final optics in currentOpticsList) {
      opticsListVersusOpticsNode[optics.id] = <int>[];
    }

    final nodes = currentOpticsTree.nodes;
    for (final node in nodes.keys) {
      opticsListVersusOpticsNode[node.data.id]!.add(node.id);
    }
  }

  late List<Optics> currentOpticsList;
  late Graph<Optics> currentOpticsTree;
  late Beam currentBeam;
  // 対応関係
  late final Map<String, List<int>> opticsListVersusOpticsNode = {};

  void addNode(Node newNode, Node previousNode, bool willReflect) {
    // ノードを作る
    if (newNode.data.runtimeType == PolarizingBeamSplitter) {
      currentOpticsTree.nodes[newNode] = [null, null];
    } else {
      currentOpticsTree.nodes[newNode] = [];
    }

    if (previousNode.data.runtimeType == PolarizingBeamSplitter) {
      if (willReflect) {
        currentOpticsTree.nodes[previousNode]![1] = newNode;
      } else {
        currentOpticsTree.nodes[previousNode]![0] = newNode;
      }
    } else {
      // Graphに追加する
      currentOpticsTree.nodes[previousNode]!.add(newNode);
    }

    // もし既存のものがあるなら
    if (currentOpticsTree.nodes.keys
        .map((node) => node.data)
        .toList()
        .contains(newNode.data)) {
      opticsListVersusOpticsNode[newNode.data.id]!.add(newNode.id);
    } else {
      opticsListVersusOpticsNode[newNode.data.id] = [newNode.id];
    }
    notifyListeners();
  }

  void deleteNode(Node node) {
    print('${node.id} ${node.data.name}');
    // 繋がりを消す
    for (final edge in currentOpticsTree.nodes.values) {
      final index = edge.indexOf(node);
      if (index != -1) {
        edge[index] = null;
      }
    }

    // nodeを消す
    currentOpticsTree.nodes.remove(node);
    // 対応関係を消す
    opticsListVersusOpticsNode[node.data.id]!.remove(node.id);

    notifyListeners();
  }

  void addOptics(Optics optics) {
    currentOpticsList.add(optics);
    opticsListVersusOpticsNode[optics.id] = [];
    notifyListeners();
  }

  void deleteOptics(Optics optics) {
    // Listから削除
    if (opticsListVersusOpticsNode[optics.id]!.isEmpty) {
      currentOpticsList.remove(optics);
      notifyListeners();
    }
  }

  void editOptics(Optics optics) {
    // keyを変える
    for (final nodeId in opticsListVersusOpticsNode[optics.id]!) {
      currentOpticsTree.nodes.keys.elementAt(nodeId).data = optics;
    }
    // valueを変える
    for (final edges in currentOpticsTree.nodes.values) {
      for (final edge in edges) {
        final nodeIDs = opticsListVersusOpticsNode[optics.id]!;
        if (edge != null && nodeIDs.contains(edge.id)) {
          edge.data = optics;
        }
      }
    }
    // Listの値を変える
    final index =
        currentOpticsList.map((e) => e.id).toList().indexOf(optics.id);
    currentOpticsList[index] = optics;
    notifyListeners();
  }

  /*void editOpticsValue(Optics optics) {
    for (final nodeId in opticsListVersusOpticsNode[optics.id]!) {
      currentOpticsTree.nodes.keys.elementAt(nodeId).data = optics;
    }
    notifyListeners();
  }*/

  void editBeam(Beam newBeam) {
    currentBeam = newBeam;
    notifyListeners();
  }
}
