import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart';

import '../beam_information/beam.dart';
import '../optics_diagram/optics.dart';
import '../utils/graph.dart';

class SimulationResult {
  SimulationResult(
      this.reflectionPositions, this.simulatedBeamList);
  final List<List<Map<int, Vector3>>> reflectionPositions;
  final List<Beam> simulatedBeamList;
}


final simulationServiceProvider = Provider(
  (ref) => SimulationService(),
);

class SimulationService {
  SimulationResult runSimulation({
    required Beam currentBeam,
    required Graph<Optics> currentOpticsTree,
    required List<Optics> currentOpticsList,
  }) {
    // 初期化
    final _seen = List.generate(
      currentOpticsTree.nodes.keys.length,
      (index) => false,
    );
    final reflectionPosition = [
      [
        {-1: currentBeam.startFrom.vector}
      ],
    ];

    var branchID = 0;
    final _simulatedBeamList = [
      Beam(
        type: currentBeam.type,
        waveLength: currentBeam.waveLength,
        beamWaist: currentBeam.beamWaist,
        startFrom: currentBeam.startFrom,
      ),
    ];

    // 深さ優先探索
    void _dfs(Graph<Optics> g, Node<Optics> v) {
      _seen[v.id] = true;
      final nodes = g.nodes[v];

      // 枝分かれを検出した時
      if (nodes!.length > 1) {
        for (var i = 0; i < nodes.length - 1; i++) {
          final tmpBeam = Beam(
            type: _simulatedBeamList[branchID].type,
            waveLength: _simulatedBeamList[branchID].waveLength,
            beamWaist: _simulatedBeamList[branchID].beamWaist,
            startFrom: _simulatedBeamList[branchID].startFrom,
          )..reachTo(v.data);
          _simulatedBeamList.add(tmpBeam);

          reflectionPosition.add([
            {v.id: tmpBeam.startPositionVector}
          ]);
        }
      }

      final position = _simulatedBeamList[branchID].reflect(v.data);
      reflectionPosition[branchID].add({v.id: position});

      for (final nextV in nodes) {
        if (_seen[nextV.id]) {
          continue;
        }
        _dfs(g, nextV);
      }
      // 末端に到達した数 = 枝の数
      if (nodes.isEmpty) {
        branchID++;
      }
    }

    _dfs(
      currentOpticsTree,
      currentOpticsTree.nodes.keys.first,
    );
    return SimulationResult(reflectionPosition,_simulatedBeamList);
  }
}
