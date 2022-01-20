import '../optics_diagram/optics.dart';
import 'package:graphs/graphs.dart';

import 'environments_variables.dart';

class Graph<T extends Optics> {
  Graph(this.nodes);
  final Map<Node<T>, List<Node<T>>> nodes;
}

class Node<T extends Optics> {
  Node(this.id, this.data,{this.isTransparent=false});
  final int id;
  final T data;
  final bool isTransparent;


  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => other is Node && other.id == id;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => id.hashCode;

  @override
  String toString() => '<$id -> $data>';
}
