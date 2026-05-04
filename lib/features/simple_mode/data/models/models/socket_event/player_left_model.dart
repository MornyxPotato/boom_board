import 'package:boom_board/core/data/models/models/player_model.dart';

class PlayerLeftModel {
  final String leftPlayerId;
  final String newHostId;
  final List<PlayerModel> playerList;

  PlayerLeftModel({
    required this.leftPlayerId,
    required this.newHostId,
    required this.playerList,
  });

  static PlayerLeftModel fromJson(Map<String, dynamic> json) {
    final List<PlayerModel> playerList = [];
    for (final player in json['players']) {
      playerList.add(PlayerModel.fromJson(player));
    }

    return PlayerLeftModel(
      leftPlayerId: json['leftPlayerId'],
      newHostId: json['newHostId'],
      playerList: playerList,
    );
  }
}
