class PlayerReadyEvent {
  final String playerId;
  final int? throwOrder;

  PlayerReadyEvent({required this.playerId, this.throwOrder});

  @override
  String toString() {
    return 'PlayerReadyEvent playerId: $playerId, throwOrder: $throwOrder';
  }
}
