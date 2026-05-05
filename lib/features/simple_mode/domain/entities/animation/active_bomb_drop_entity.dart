// Helper class to track active bomb animations
class ActiveBombDropEntity {
  final String id;
  final String bomberId;
  final int startX; // Where it comes from
  final int startY;
  final int targetX; // Where it lands
  final int targetY;

  ActiveBombDropEntity({
    required this.id,
    required this.bomberId,
    required this.startX,
    required this.startY,
    required this.targetX,
    required this.targetY,
  });

  @override
  String toString() {
    return 'ActiveBombDropEntity id: $id, bomberId: $bomberId, startX: $startX, startY: $startY, targetX: $targetX, targetY: $targetY';
  }
}
