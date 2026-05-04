import 'package:boom_board/features/simple_mode/data/models/requests/start_game_request.dart';
import 'package:boom_board/features/simple_mode/domain/repositories/simple_mode_server_repository.dart';

class StartGameParams {
  final String roomCode;

  StartGameParams({required this.roomCode});
}

class StartGameUseCase {
  final SimpleModeServerRepository simpleModeServerRepository;

  StartGameUseCase({required this.simpleModeServerRepository});

  Future<void> call(StartGameParams params) async {
    await simpleModeServerRepository.startGame(
      StartGameRequest(
        roomCode: params.roomCode,
      ),
    );
  }
}
