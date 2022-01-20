import '../optics_diagram/optics.dart';
import 'package:graphs/graphs.dart';

import 'environments_variables.dart';

class Graph<T extends Optics> {
  Graph(this.nodes);
  final Map<Node<T>, List<Node<T>>> nodes;
}

class Node<T extends Optics> {
  Node(this.id, this.data);
  final int id;
  final T data;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => other is Node && other.id == id;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => id.hashCode;

  @override
  String toString() => '<$id -> $data>';
}

List<bool> seen =
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
