import 'package:boom_board/core/data/models/enums/game_mode.dart';
import 'package:boom_board/core/data/models/models/player_model.dart';

class CreateRoomRequest {
  final String playerName;

  CreateRoomRequest({required this.playerName});

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
    };
  }
}

class CreateRoomResponse {
  final String roomCode;
  final GameMode gameMode;
  final String hostId;
  final List<PlayerModel> playerList;

  CreateRoomResponse({
    required this.roomCode,
    required this.gameMode,
    required this.hostId,
    required this.playerList,
  });

  static CreateRoomResponse fromJson(Map<String, dynamic> json) {
    final List<PlayerModel> playerList = [];
    for (final data in json['players']) {
      playerList.add(PlayerModel.fromJson(data));
    }

    return CreateRoomResponse(
      roomCode: json['roomCode'],
      gameMode: GameMode.fromString(json['gameMode']),
      hostId: json['hostId'],
      playerList: playerList,
    );
  }
}
