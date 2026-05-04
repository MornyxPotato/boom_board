import 'package:boom_board/features/simple_mode/domain/entities/simple_mode_player_entity.dart';

class PlayerJoinedEvent {
  final String playerId;
  final String playerName;
  final List<SimpleModePlayerEntity> playerList;

  PlayerJoinedEvent({
    required this.playerId,
    required this.playerName,
    required this.playerList,
  });

  @override
  String toString() {
    return 'PlayerJoinedEvent playerId: $playerId, playerName: $playerName, playerList: $playerList';
  }
}
