import 'package:boom_board/features/simple_mode/domain/entities/simple_mode_player_entity.dart';

class GameResetEvent {
  final List<SimpleModePlayerEntity> playerList;

  GameResetEvent({required this.playerList});

  @override
  String toString() {
    return 'GameResetEvent playerList: $playerList';
  }
}
