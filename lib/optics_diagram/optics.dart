class OpticsPosition {
  OpticsPosition({
    required this.x,
    required this.y,
    required this.z,
    required this.theta,
    required this.phi,
  });

  final double x;
  final double y;
  final double z;
  final double theta;
  final double phi;
}

// リスト項目のデータ構造
class Optics {
  Optics(this.id, this.name, this.position);
  String id;
  String name;
  OpticsPosition position;
}
