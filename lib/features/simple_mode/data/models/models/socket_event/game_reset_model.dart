import 'package:boom_board/core/data/models/models/player_model.dart';

class GameResetModel {
  final List<PlayerModel> playerList;

  GameResetModel({required this.playerList});

  static GameResetModel fromJson(Map<String, dynamic> json) {
    final List<PlayerModel> playerList = [];
    for (final player in json['players']) {
      playerList.add(PlayerModel.fromJson(player));
    }

    return GameResetModel(playerList: playerList);
  }
}
