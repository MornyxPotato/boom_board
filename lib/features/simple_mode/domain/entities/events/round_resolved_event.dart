import 'package:boom_board/core/data/models/coordinate.dart';
import 'package:boom_board/features/simple_mode/domain/entities/action_log_entity.dart';
import 'package:boom_board/features/simple_mode/domain/entities/explosion_result_entity.dart';
import 'package:boom_board/features/simple_mode/domain/entities/simple_mode_player_entity.dart';

class RoundResolvedEvent {
  final List<ExplosionResultEntity> explosionList;
  final List<SimpleModePlayerEntity> playerList;
  final List<Coordinate> destroyedTiles;
  final List<Coordinate> newDestroyedTiles;
  final List<ActionLogEntity> newLogs;
  final int roundNumber;

  RoundResolvedEvent({
    required this.explosionList,
    required this.playerList,
    required this.destroyedTiles,
    required this.newDestroyedTiles,
    required this.newLogs,
    required this.roundNumber,
  });

  @override
  String toString() {
    return 'RoundResolvedEvent explosionList: $explosionList, playerList: $playerList, destroyedTiles: $destroyedTiles, newDestroyedTiles: $newDestroyedTiles, newLogs: $newLogs, roundNumber: $roundNumber';
  }
}
