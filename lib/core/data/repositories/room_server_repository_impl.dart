import 'package:boom_board/core/data/data_source/room_socket_service.dart';
import 'package:boom_board/core/data/models/mapper/create_room_extension.dart';
import 'package:boom_board/core/data/models/mapper/join_room_extension.dart';
import 'package:boom_board/core/data/models/requests/create_room_request.dart';
import 'package:boom_board/core/data/models/requests/join_room_request.dart';
import 'package:boom_board/core/domain/entities/create_room_entity.dart';
import 'package:boom_board/core/domain/entities/join_room_entity.dart';
import 'package:boom_board/core/domain/repositories/room_server_repository.dart';

class RoomServerRepositoryImpl implements RoomServerRepository {
  final RoomSocketService socketService;

  RoomServerRepositoryImpl({required this.socketService});

  @override
  Future<CreateRoomEntity> createRoom(CreateRoomRequest request) async {
    final resp = await socketService.createRoom(request: request);

    return resp.toEntity();
  }

  @override
  Future<JoinRoomEntity> joinRoom(JoinRoomRequest request) async {
    final resp = await socketService.joinRoom(request: request);

    return resp.toEntity();
  }

  @override
  Future<void> leaveRoom() async {
    await socketService.leaveRoom();
  }
}
