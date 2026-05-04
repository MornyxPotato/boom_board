import 'package:boom_board/core/data/models/enums/game_mode.dart';
import 'package:boom_board/core/data/models/models/player_model.dart';

class JoinRoomRequest {
  final String playerName;
  final String roomCode;

  JoinRoomRequest({
    required this.playerName,
    required this.roomCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'roomCode': roomCode,
    };
  }
}

class JoinRoomResponse {
  final String roomCode;
  final GameMode gameMode;
  final String hostId;
  final List<PlayerModel> playerList;

  JoinRoomResponse({
    required this.roomCode,
    required this.gameMode,
    required this.hostId,
    required this.playerList,
  });

  static JoinRoomResponse fromJson(Map<String, dynamic> json) {
    final List<PlayerModel> playerList = [];
    for (final data in json['players']) {
      playerList.add(PlayerModel.fromJson(data));
    }
    return JoinRoomResponse(
      roomCode: json['roomCode'],
      gameMode: GameMode.fromString(json['gameMode']),
      hostId: json['hostId'],
      playerList: playerList,
    );
  }
}
