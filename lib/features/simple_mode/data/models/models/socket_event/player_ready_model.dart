class PlayerReadyModel {
  final String playerId;
  final int? throwOrder;

  PlayerReadyModel({required this.playerId, this.throwOrder});

  static PlayerReadyModel fromJson(Map<String, dynamic> json) {
    return PlayerReadyModel(
      playerId: json['playerId'],
      throwOrder: json['throwOrder'],
    );
  }
}
