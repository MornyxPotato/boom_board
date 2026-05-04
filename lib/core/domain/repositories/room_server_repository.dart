import 'package:boom_board/core/data/models/requests/create_room_request.dart';
import 'package:boom_board/core/data/models/requests/join_room_request.dart';
import 'package:boom_board/core/domain/entities/create_room_entity.dart';
import 'package:boom_board/core/domain/entities/join_room_entity.dart';

abstract class RoomServerRepository {
  Future<CreateRoomEntity> createRoom(CreateRoomRequest request);

  Future<JoinRoomEntity> joinRoom(JoinRoomRequest request);

  Future<void> leaveRoom();
}
