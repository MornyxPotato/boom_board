class PlayerReadyEvent {
  final String playerId;

  PlayerReadyEvent({required this.playerId});

  @override
  String toString() {
    return 'PlayerReadyEvent playerId: $playerId';
  }
}
