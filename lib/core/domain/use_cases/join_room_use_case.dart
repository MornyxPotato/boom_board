import 'package:boom_board/core/data/models/enums/game_mode.dart';
import 'package:boom_board/core/data/models/requests/join_room_request.dart';
import 'package:boom_board/core/domain/entities/join_room_entity.dart';
import 'package:boom_board/core/domain/repositories/room_server_repository.dart';
import 'package:boom_board/features/simple_mode/data/data_source/simple_mode_socket_handler.dart';

class JoinRoomParams {
  final String playerName;
  final String roomCode;

  JoinRoomParams({required this.playerName, required this.roomCode});
}

class JoinRoomUseCase {
  final RoomServerRepository roomServerRepository;
  final SimpleModeSocketHandler simpleModeSocketHandler;

  JoinRoomUseCase({
    required this.roomServerRepository,
    required this.simpleModeSocketHandler,
  });

  Future<JoinRoomEntity> call(JoinRoomParams params) async {
    final result = await roomServerRepository.joinRoom(
      JoinRoomRequest(playerName: params.playerName, roomCode: params.roomCode),
    );

    if (result.gameMode == GameMode.simple) {
      simpleModeSocketHandler.init();
    }

    return result;
  }
}
