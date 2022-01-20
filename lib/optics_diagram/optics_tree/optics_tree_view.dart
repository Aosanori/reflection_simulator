import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../utils/environments_variables.dart';
import '../../utils/graph.dart';

import '../optics.dart';

class OpticsTreeView extends HookConsumerWidget {
  const OpticsTreeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seen =
        List.generate(initialOpticsTree.nodes.keys.length, (index) => false);
    void dfs(Graph<Optics> g, Node<Optics> v) {
      seen[v.id] = true;
      final nodes = g.nodes[v];
      print(v.id);
      for (final nextV in nodes!) {
        if (seen[nextV.id]) {
          continue;
        }
        dfs(g, nextV);
      }
    }

    dfs(
      initialOpticsTree,
      Node(
        0,
        initialOpticsList[0],
        // どこと繋がっているか
      ),
    );
    return Container();
  }
}
