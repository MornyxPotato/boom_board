import 'package:boom_board/core/data/models/models/player_model.dart';
import 'package:boom_board/features/simple_mode/data/models/models/action_log_model.dart';

class PlayerDroppedModel {
  final String droppedPlayerId;
  final String newHostId;
  final List<PlayerModel> playerList;
  final List<ActionLogModel> newLogs;

  PlayerDroppedModel({
    required this.droppedPlayerId,
    required this.newHostId,
    required this.playerList,
    required this.newLogs,
  });

  static PlayerDroppedModel fromJson(Map<String, dynamic> json) {
    final List<PlayerModel> playerList = [];
    for (final player in json['players']) {
      playerList.add(PlayerModel.fromJson(player));
    }

    final List<ActionLogModel> newLogs = [];
    for (final log in json['newLogs']) {
      newLogs.add(ActionLogModel.fromJson(log));
    }

    return PlayerDroppedModel(
      droppedPlayerId: json['droppedPlayerId'],
      newHostId: json['newHostId'],
      playerList: playerList,
      newLogs: newLogs,
    );
  }
}
