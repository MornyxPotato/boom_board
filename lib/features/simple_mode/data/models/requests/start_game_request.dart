class StartGameRequest {
  final String roomCode;

  StartGameRequest({required this.roomCode});

  Map<String, dynamic> toJson() {
    return {'roomCode': roomCode};
  }
}
