class ResetGameRequest {
  final String roomCode;

  ResetGameRequest({required this.roomCode});

  Map<String, dynamic> toJson() {
    return {'roomCode': roomCode};
  }
}
