class Coordinate {
  final int x;
  final int y;

  Coordinate({
    required this.x,
    required this.y,
  });

  static Coordinate fromJson(Map<String, dynamic> json) {
    return Coordinate(x: json['x'], y: json['y']);
  }

  @override
  String toString() {
    return 'Coordinate x: $x, y: $y';
  }

  @override
  bool operator ==(Object other) {
    if (other is! Coordinate) return false;
    return x == other.x && y == other.y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
