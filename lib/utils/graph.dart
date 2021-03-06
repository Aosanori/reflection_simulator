import '../optics_diagram/optics.dart';

class Graph<T extends Optics> {
  Graph(this.nodes);
  final Map<Node, List<Node?>> nodes;

  Graph copy() {
    final clone = <Node, List<Node?>>{};
    nodes.forEach((node, edges) {
      final clonedNode = node.copy();
      final clonedEdges = edges.map((edge) {
        if (edge != null) {
          return edge.copy();
        }
        return null;
      }).toList();
      clone[clonedNode] = clonedEdges;
    });
    return Graph(clone);
  }

  Map<String, Optics> get opticsWithNodeID => nodes.map<String, Optics>(
        (key, value) => MapEntry(key.id, key.data),
      );
}

class Node {
  Node(this.id, this.data, {this.isTransparent = false});
  final String id;
  Optics data;
  final bool isTransparent;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => other is Node && other.id == id;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => id.hashCode;

  @override
  String toString() => '<$id -> $data>';

  Node copy() => Node(id, data.copy(), isTransparent: isTransparent);
}
