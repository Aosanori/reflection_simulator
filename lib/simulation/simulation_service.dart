import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart';

import '../beam_information/beam.dart';
import '../optics_diagram/optics.dart';
import '../utils/graph.dart';
import 'simulation_result.dart';

final simulationServiceProvider = Provider(
  (ref) => SimulationService(),
);

class SimulationService {
  SimulationResult runSimulation({
    required Beam currentBeam,
    required Graph<Optics> currentOpticsTree,
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
    // TODO PBSで分けれるようにする
    void _dfs(Graph<Optics> g, Node v) {
      _seen[v.id] = true;
      // next
      final nodes = g.nodes[v];

      /*
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
      reflectionPosition[branchID].add({v.id: position});*/

      //透過ならばindex0 反射ならindex1とする
      /*Beam(
        type: _simulatedBeamList[branchID].type,
        waveLength: _simulatedBeamList[branchID].waveLength,
        beamWaist: _simulatedBeamList[branchID].beamWaist,
        startFrom: _simulatedBeamList[branchID].startFrom,
      );*/
      //final tmpBeam = _simulatedBeamList[branchID];
      //print('${v.data.name}');
      //print(tmpBeam.direction);

      if (v.data.runtimeType == PolarizingBeamSplitter) {
        Vector3? position;
        // ok (枝分かれがある時)
        if (!nodes!.contains(null)) {
          _simulatedBeamList.add(_simulatedBeamList[branchID].copy());
          reflectionPosition.add([
            {v.id: _simulatedBeamList[branchID].startPositionVector}
          ]);
        }

        var offsetBranch = 0;
        if (nodes[0] != null) {
          position = _simulatedBeamList[branchID].reachTo(v.data);
          offsetBranch++;
        }
        if (nodes[1] != null) {
          position =
              _simulatedBeamList[branchID + offsetBranch].reflect(v.data);
        }

        _simulatedBeamList[branchID].passedOptics.add(v.data);

        if(offsetBranch == 1){
          _simulatedBeamList[branchID+ offsetBranch].passedOptics.add(v.data);
          reflectionPosition[branchID+ offsetBranch].add({v.id: position!});
        }

        reflectionPosition[branchID].add({v.id: position!});
      }

      if (v.data.runtimeType == Mirror) {
        final position = _simulatedBeamList[branchID].reflect(v.data);
        _simulatedBeamList[branchID].passedOptics.add(v.data);
        reflectionPosition[branchID].add({v.id: position});
      }

      for (final nextV in nodes!) {
        if (nextV != null) {
          if (_seen[nextV.id]) {
            continue;
          }
          _dfs(g, nextV);
        }
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
    return SimulationResult(reflectionPosition, _simulatedBeamList);
  }
}
