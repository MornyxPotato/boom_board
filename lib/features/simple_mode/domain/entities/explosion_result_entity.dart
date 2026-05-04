class ExplosionResultEntity {
  final String bomberId;
  final String? victimId;
  final bool isHit;
  final int x;
  final int y;

  ExplosionResultEntity({
    required this.bomberId,
    required this.isHit,
    required this.x,
    required this.y,
    this.victimId,
  });

  @override
  String toString() {
    return 'ExplosionResultEntity bomberId: $bomberId, victimId: $victimId, isHit: $isHit, x: $x, y: $y';
  }
}
