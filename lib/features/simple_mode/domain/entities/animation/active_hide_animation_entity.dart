class ActiveHideAnimationEntity {
  final String id;
  final String playerId;
  final bool isLocal;
  final int startX;
  final int startY;
  final int edgeX;
  final int edgeY;
  final int? targetX; // Only the local player has a target!
  final int? targetY;

  ActiveHideAnimationEntity({
    required this.id,
    required this.playerId,
    required this.isLocal,
    required this.startX,
    required this.startY,
    required this.edgeX,
    required this.edgeY,
    this.targetX,
    this.targetY,
  });
}
