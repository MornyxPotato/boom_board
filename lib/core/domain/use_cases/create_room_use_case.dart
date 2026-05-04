import 'package:boom_board/core/data/models/enums/game_mode.dart';
import 'package:boom_board/core/data/models/requests/create_room_request.dart';
import 'package:boom_board/core/domain/entities/create_room_entity.dart';
import 'package:boom_board/core/domain/repositories/room_server_repository.dart';
import 'package:boom_board/features/simple_mode/data/data_source/simple_mode_socket_handler.dart';

class CreateRoomParams {
  final String playerName;

  CreateRoomParams({required this.playerName});
}

class CreateRoomUseCase {
  final RoomServerRepository roomServerRepository;
  final SimpleModeSocketHandler simpleModeSocketHandler;

  CreateRoomUseCase({
    required this.roomServerRepository,
    required this.simpleModeSocketHandler,
  });

  Future<CreateRoomEntity> call(CreateRoomParams params) async {
    final result = await roomServerRepository.createRoom(
      CreateRoomRequest(
        playerName: params.playerName,
      ),
    );

    if (result.gameMode == GameMode.simple) {
      simpleModeSocketHandler.init();
    }

    return result;
  }
}
