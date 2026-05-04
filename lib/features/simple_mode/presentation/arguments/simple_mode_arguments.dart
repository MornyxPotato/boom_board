import 'package:boom_board/features/simple_mode/domain/entities/simple_mode_player_entity.dart';

class SimpleModeArguments {
  final String roomCode;
  final String hostId;
  final List<SimpleModePlayerEntity> playerList;

  SimpleModeArguments({
    required this.roomCode,
    required this.hostId,
    required this.playerList,
  });
}
