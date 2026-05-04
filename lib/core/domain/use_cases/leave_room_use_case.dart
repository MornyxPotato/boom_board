import 'package:boom_board/core/data/models/enums/game_mode.dart';
import 'package:boom_board/core/domain/repositories/room_server_repository.dart';
import 'package:boom_board/features/simple_mode/data/data_source/simple_mode_socket_handler.dart';

class LeaveRoomParams {
  final GameMode gameMode;

  LeaveRoomParams({required this.gameMode});
}

class LeaveRoomUseCase {
  final RoomServerRepository roomServerRepository;
  final SimpleModeSocketHandler simpleModeSocketHandler;

  LeaveRoomUseCase({
    required this.roomServerRepository,
    required this.simpleModeSocketHandler,
  });

  Future<void> call(LeaveRoomParams params) async {
    await roomServerRepository.leaveRoom();

    if (params.gameMode == GameMode.simple) {
      simpleModeSocketHandler.dispose();
    }
  }
}
