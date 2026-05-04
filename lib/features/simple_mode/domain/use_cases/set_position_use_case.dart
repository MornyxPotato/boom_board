import 'package:boom_board/features/simple_mode/data/models/requests/set_position_request.dart';
import 'package:boom_board/features/simple_mode/domain/repositories/simple_mode_server_repository.dart';

class SetPositionParams {
  final String roomCode;
  final int x;
  final int y;

  SetPositionParams({
    required this.roomCode,
    required this.x,
    required this.y,
  });
}

class SetPositionUseCase {
  final SimpleModeServerRepository simpleModeServerRepository;

  SetPositionUseCase({required this.simpleModeServerRepository});

  Future<void> call(SetPositionParams params) async {
    await simpleModeServerRepository.setPosition(
      SetPositionRequest(
        roomCode: params.roomCode,
        x: params.x,
        y: params.y,
      ),
    );
  }
}
