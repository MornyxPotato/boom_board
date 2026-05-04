import 'package:boom_board/core/data/models/enums/game_mode.dart';
import 'package:boom_board/core/domain/entities/player_entity.dart';

class JoinRoomEntity {
  final String roomCode;
  final GameMode gameMode;
  final String hostId;
  final List<PlayerEntity> playerList;

  JoinRoomEntity({
    required this.roomCode,
    required this.gameMode,
    required this.hostId,
    required this.playerList,
  });
}
