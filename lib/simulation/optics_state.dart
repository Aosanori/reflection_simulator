import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../beam_information/beam.dart';
import '../common/view_model_change_notifier.dart';
import '../optics_diagram/optics.dart';
import '../utils/environments_variables.dart';
import '../utils/graph.dart';

final opticsStateProvider = ChangeNotifierProvider(
  (ref) => OpticsState(),
);

class OpticsState extends ViewModelChangeNotifier {
  OpticsState() {
    currentOpticsList = initialOpticsList;
    currentOpticsTree = initialOpticsTree;
    currentBeam = initialBeam;

    for (final optics in currentOpticsList) {
      _opticsListVersusOpticsNode[optics.id] = <int>[];
    }

    final nodes = currentOpticsTree.nodes;
    for (final node in nodes.keys) {
      _opticsListVersusOpticsNode[node.data.id]!.add(node.id);
    }
  }

  late List<Optics> currentOpticsList;
  late Graph<Optics> currentOpticsTree;
  late Beam currentBeam;
  // 対応関係
  late final Map<String, List<int>> _opticsListVersusOpticsNode = {};

  void addOptics(Optics optics, Node previousNode) {}

  void editOptics(Optics optics) {
    for (final nodeId in _opticsListVersusOpticsNode[optics.id]!) {
      currentOpticsTree.nodes.keys.elementAt(nodeId).data = optics;
    }
    notifyListeners();
  }

  void editOpticsValue(Optics optics) {
    for (final nodeId in _opticsListVersusOpticsNode[optics.id]!) {
      currentOpticsTree.nodes.keys.elementAt(nodeId).data = optics;
    }
    notifyListeners();
  }

  void editBeam(Beam newBeam) {
    currentBeam = newBeam;
    notifyListeners();
  }

  void deleteOptics(int id) {}
}
