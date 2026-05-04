class PlayerReadyModel {
  final String playerId;

  PlayerReadyModel({required this.playerId});

  static PlayerReadyModel fromJson(Map<String, dynamic> json) {
    return PlayerReadyModel(playerId: json['playerId']);
  }
}
