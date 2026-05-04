import 'package:boom_board/core/utils/socket_service.dart';

class GetCurrentPlayerIdUseCase {
  final SocketService socketService;

  GetCurrentPlayerIdUseCase({required this.socketService});

  String? call() {
    return socketService.socket.id;
  }
}
