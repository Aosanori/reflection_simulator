import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../beam_information/beam.dart';
import '../common/view_model_change_notifier.dart';
import '../optics_diagram/optics.dart';
import '../utils/environments_variables.dart';
import '../utils/graph.dart';
import '../utils/random_string.dart';

final opticsStateActionProvider =
    Provider((ref) => OpticsStateAction(ref.watch(opticsStateProvider)));

class OpticsStateAction {
  OpticsStateAction(this._opticsState);
  final OpticsState _opticsState;

  void addFirstNode(Optics newOptics) {
    _opticsState.addFirstNode(Node(randomString(4), newOptics));
  }

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
    currentOpticsList = [];
    currentOpticsTree = Graph({});
    currentBeam = initialBeam;
    opticsListVersusOpticsNode = {};

    for (final optics in currentOpticsList) {
      opticsListVersusOpticsNode[optics.id] = <Node>[];
    }

    final nodes = currentOpticsTree.nodes;
    for (final node in nodes.keys) {
      opticsListVersusOpticsNode[node.data.id]!.add(node);
    }
  }

  late List<Optics> currentOpticsList;
  late Graph<Optics> currentOpticsTree;
  late Beam currentBeam;
  // 対応関係
  late Map<String, List<Node>> opticsListVersusOpticsNode;

  void addFirstNode(Node newNode) {
    // ノードを作る
    if (newNode.data.runtimeType == PolarizingBeamSplitter) {
      currentOpticsTree.nodes[newNode] = [null, null];
    } else {
      currentOpticsTree.nodes[newNode] = [null];
    }
    opticsListVersusOpticsNode[newNode.data.id] = <Node>[newNode];
    print(newNode.data.id);
    print(opticsListVersusOpticsNode[newNode.data.id]);
    notifyListeners();
  }

  void addNode(Node newNode, Node previousNode, bool willReflect) {
    // ノードを作る
    if (newNode.data.runtimeType == PolarizingBeamSplitter) {
      currentOpticsTree.nodes[newNode] = [null, null];
    } else {
      currentOpticsTree.nodes[newNode] = [null];
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
      opticsListVersusOpticsNode[newNode.data.id]!.add(newNode);
    } else {
      opticsListVersusOpticsNode[newNode.data.id] = [newNode];
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
    opticsListVersusOpticsNode[node.data.id]!.remove(node);

    notifyListeners();
  }

  void addOptics(Optics optics) {
    currentOpticsList.add(optics);
    if (opticsListVersusOpticsNode[optics.id] == null) {
      opticsListVersusOpticsNode[optics.id] = [];
    }
    notifyListeners();
  }

  void deleteOptics(Optics optics) {
    // Listから削除
    if (opticsListVersusOpticsNode[optics.id]!.isEmpty) {
      currentOpticsList.remove(optics);
      notifyListeners();
      return;
    }

    // Listから削除
    currentOpticsList.remove(optics);

    // 対応するNode
    final nodes = opticsListVersusOpticsNode[optics.id]!;
    final nodeIDs =
        opticsListVersusOpticsNode[optics.id]!.map((e) => e.id).toList();

    for (final edges in currentOpticsTree.nodes.values) {
      final index = edges.map((e) => e?.data).toList().indexOf(optics);
      if (index != -1) {
        edges[index] = null;
      }
    }

    for (final node in nodes) {
      currentOpticsTree.nodes.removeWhere((key, value) => key == node);
    }

    opticsListVersusOpticsNode
        .removeWhere((key, value) => nodeIDs.contains(key));
    notifyListeners();
  }

  void editOptics(Optics optics) {
    // keyを変える
    for (final node in opticsListVersusOpticsNode[optics.id]!) {
      final index = currentOpticsTree.nodes.keys
          //.map((e) => e.id)
          .toList()
          .indexOf(node);
      currentOpticsTree.nodes.keys.elementAt(index).data = optics;
      for (final node in opticsListVersusOpticsNode[optics.id]!) {
        node.data = optics;
      }
    }
    // 他からPBS
    if (optics.runtimeType == PolarizingBeamSplitter) {}
    // valueを変える
    for (final edges in currentOpticsTree.nodes.values) {
      for (final edge in edges) {
        final nodes = opticsListVersusOpticsNode[optics.id]!;
        if (edge != null && nodes.contains(edge)) {
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

  void editBeam(Beam newBeam) {
    currentBeam = newBeam;
    notifyListeners();
  }
}
