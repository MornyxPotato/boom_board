import 'package:boom_board/features/simple_mode/data/models/requests/reset_game_request.dart';
import 'package:boom_board/features/simple_mode/data/models/requests/set_position_request.dart';
import 'package:boom_board/features/simple_mode/data/models/requests/start_game_request.dart';
import 'package:boom_board/features/simple_mode/data/models/requests/throw_bomb_request.dart';

abstract class SimpleModeServerRepository {
  Future<void> startGame(StartGameRequest request);

  Future<void> setPosition(SetPositionRequest request);

  Future<ThrowBombResponse?> throwBomb(ThrowBombRequest request);

  Future<void> resetGame(ResetGameRequest request);
}
