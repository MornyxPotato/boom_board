import 'package:boom_board/features/simple_mode/data/models/requests/reset_game_request.dart';
import 'package:boom_board/features/simple_mode/domain/repositories/simple_mode_server_repository.dart';

class ResetGameParams {
  final String roomCode;

  ResetGameParams({required this.roomCode});
}

class ResetGameUseCase {
  final SimpleModeServerRepository simpleModeServerRepository;

  ResetGameUseCase({required this.simpleModeServerRepository});

  Future<void> call(ResetGameParams params) async {
    await simpleModeServerRepository.resetGame(
      ResetGameRequest(
        roomCode: params.roomCode,
      ),
    );
  }
}
