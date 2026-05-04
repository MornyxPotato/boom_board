import 'package:boom_board/features/simple_mode/data/models/requests/throw_bomb_request.dart';
import 'package:boom_board/features/simple_mode/domain/repositories/simple_mode_server_repository.dart';

class ThrowBombParams {
  final String roomCode;
  final int x;
  final int y;

  ThrowBombParams({
    required this.roomCode,
    required this.x,
    required this.y,
  });
}

class ThrowBombUseCase {
  final SimpleModeServerRepository simpleModeServerRepository;

  ThrowBombUseCase({required this.simpleModeServerRepository});

  Future<void> call(ThrowBombParams params) async {
    await simpleModeServerRepository.throwBomb(
      ThrowBombRequest(
        roomCode: params.roomCode,
        x: params.x,
        y: params.y,
      ),
    );
  }
}
