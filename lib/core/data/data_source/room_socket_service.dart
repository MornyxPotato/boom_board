import 'package:boom_board/core/data/models/requests/create_room_request.dart';
import 'package:boom_board/core/data/models/requests/join_room_request.dart';
import 'package:boom_board/core/exceptions/invalid_socket_response_exception.dart';
import 'package:boom_board/core/utils/socket_service.dart';

class RoomSocketService {
  final SocketService socketService;

  RoomSocketService({required this.socketService});

  Future<CreateRoomResponse> createRoom({required CreateRoomRequest request}) async {
    final resp = await socketService.emitSocket(actionName: 'createRoom', data: request.toJson());

    if (resp.data == null) throw InvalidSocketResponseException();
    return CreateRoomResponse.fromJson(resp.data!);
  }

  Future<JoinRoomResponse> joinRoom({required JoinRoomRequest request}) async {
    final resp = await socketService.emitSocket(actionName: 'joinRoom', data: request.toJson());

    if (resp.data == null) throw InvalidSocketResponseException();
    return JoinRoomResponse.fromJson(resp.data!);
  }

  Future<void> leaveRoom() async {
    await socketService.emitSocket(actionName: 'leaveRoom');
  }
}
