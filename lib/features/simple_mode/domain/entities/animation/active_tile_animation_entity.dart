// Helper class for tile-locked animations (Explosions and Ghosts)
class ActiveTileAnimationEntity {
  final String id;
  final int x;
  final int y;

  ActiveTileAnimationEntity({
    required this.id,
    required this.x,
    required this.y,
  });

  @override
  String toString() {
    return 'ActiveTileAnimationEntity id: $id, x: $x, y: $y';
  }
}
