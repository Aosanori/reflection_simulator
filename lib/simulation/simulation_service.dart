import 'dart:math';

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
  Map<int, int> _preprocessing(
    Beam currentBeam,
    Graph<Optics> currentOpticsTree,
  ) {
    // 初期化
    final _seen = List.generate(
      currentOpticsTree.nodes.keys.length,
      (index) => false,
    );

    var numberOfBranches = 0;
    final nodeIDVSBranchID = <int, int>{};

    // 先にbranchIDを振ってしまう
    void _dfsForPreprocessing(Graph<Optics> g, Node v) {
      _seen[v.id] = true;
      nodeIDVSBranchID[v.id] = numberOfBranches;
      // next
      final nodes = g.nodes[v];
      for (final nextV in nodes!) {
        if (nextV != null) {
          if (_seen[nextV.id]) {
            continue;
          }
          _dfsForPreprocessing(g, nextV);
        }
      }
      // 末端に到達した数 = 枝の数
      if (nodes.isEmpty) {
        numberOfBranches++;
      }
    }

    _dfsForPreprocessing(
      currentOpticsTree,
      currentOpticsTree.nodes.keys.first,
    );

    return nodeIDVSBranchID;
  }

  SimulationResult runSimulation({
    required Beam currentBeam,
    required Graph<Optics> currentOpticsTree,
  }) {
    // 初期化
    final nodeIDVSBranchID = _preprocessing(currentBeam, currentOpticsTree);
    final numberOfBranches = nodeIDVSBranchID.values.toSet().length;

    final _seen = List.generate(
      currentOpticsTree.nodes.keys.length,
      (index) => false,
    );

    final reflectionPosition = List.generate(
      numberOfBranches,
      (index) => [
        {-1: currentBeam.startFrom.vector.clone()}
      ],
    );

    final _simulatedBeamList = List.generate(
      numberOfBranches,
      (index) => Beam(
        type: currentBeam.type,
        waveLength: currentBeam.waveLength,
        beamWaist: currentBeam.beamWaist,
        startFrom: currentBeam.startFrom,
      ),
    );

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
        // 枝分かれがある時
        //透過ならばindex0 反射ならindex1とする
        if (!nodes!.contains(null)) {
          final laterBranch = max<int>(
            nodeIDVSBranchID[nodes[0]!.id]!,
            nodeIDVSBranchID[nodes[1]!.id]!,
          );
          final baseBranch = min<int>(
            nodeIDVSBranchID[nodes[0]!.id]!,
            nodeIDVSBranchID[nodes[1]!.id]!,
          );

          _simulatedBeamList[laterBranch] =
              _simulatedBeamList[baseBranch].copy();

          position = _simulatedBeamList[baseBranch].reachTo(v.data);
          _simulatedBeamList[baseBranch].passedOptics.add(v.data);
          reflectionPosition[baseBranch].add({v.id: position});

          position = _simulatedBeamList[laterBranch].reflect(v.data);
          _simulatedBeamList[laterBranch].passedOptics.add(v.data);
          reflectionPosition[laterBranch].first = {v.id: position};
        }

        // 枝分かれがないとき
        if (nodes.contains(null)) {
          final branchID = nodeIDVSBranchID[v.id]!;

          if (nodes[0] != null) {
            position = _simulatedBeamList[branchID].reachTo(v.data);
          }
          if (nodes[1] != null) {
            position = _simulatedBeamList[branchID].reflect(v.data);
          }

          _simulatedBeamList[branchID].passedOptics.add(v.data);
          reflectionPosition[branchID].add({v.id: position!});
        }
      }

      if (v.data.runtimeType == Mirror) {
        final branchID = nodeIDVSBranchID[v.id]!;
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
    }

    _dfs(
      currentOpticsTree,
      currentOpticsTree.nodes.keys.first,
    );
    return SimulationResult(reflectionPosition, _simulatedBeamList);
  }
}
