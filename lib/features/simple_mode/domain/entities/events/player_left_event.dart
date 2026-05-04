import 'package:boom_board/features/simple_mode/domain/entities/simple_mode_player_entity.dart';

class PlayerLeftEvent {
  final String playerId;
  final String newHostId;
  final List<SimpleModePlayerEntity> playerList;

  PlayerLeftEvent({
    required this.playerId,
    required this.newHostId,
    required this.playerList,
  });

  @override
  String toString() {
    return 'PlayerLeftEvent playerId: $playerId, newHostId: $newHostId, playerList: $playerList';
  }
}
