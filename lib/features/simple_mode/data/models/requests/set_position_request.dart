class SetPositionRequest {
  final String roomCode;
  final int x;
  final int y;

  SetPositionRequest({
    required this.roomCode,
    required this.x,
    required this.y,
  });

  Map<String, dynamic> toJson() {
    return {
      'roomCode': roomCode,
      'x': x,
      'y': y,
    };
  }
}
