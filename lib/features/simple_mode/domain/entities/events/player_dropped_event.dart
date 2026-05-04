import 'package:boom_board/features/simple_mode/domain/entities/action_log_entity.dart';
import 'package:boom_board/features/simple_mode/domain/entities/simple_mode_player_entity.dart';

class PlayerDroppedEvent {
  final String droppedPlayerId;
  final String newHostId;
  final List<SimpleModePlayerEntity> playerList;
  final List<ActionLogEntity> newLogs;

  PlayerDroppedEvent({
    required this.droppedPlayerId,
    required this.newHostId,
    required this.playerList,
    required this.newLogs,
  });

  @override
  String toString() {
    return 'PlayerDroppedEvent droppedPlayerId: $droppedPlayerId, newHostId: $newHostId, playerList: $playerList, newLogs: $newLogs';
  }
}
