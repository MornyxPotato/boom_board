import 'package:boom_board/core/data/models/models/player_model.dart';

class PlayerJoinedModel {
  final String playerId;
  final String playerName;
  final List<PlayerModel> playerList;

  PlayerJoinedModel({
    required this.playerId,
    required this.playerName,
    required this.playerList,
  });

  static PlayerJoinedModel fromJson(Map<String, dynamic> json) {
    final List<PlayerModel> playerList = [];
    for (final player in json['players']) {
      playerList.add(PlayerModel.fromJson(player));
    }

    return PlayerJoinedModel(
      playerId: json['id'],
      playerName: json['name'],
      playerList: playerList,
    );
  }
}
