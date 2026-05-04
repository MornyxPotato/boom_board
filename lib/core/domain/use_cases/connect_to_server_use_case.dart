import 'package:boom_board/core/utils/socket_service.dart';

class ConnectToServerUseCase {
  final SocketService socketService;

  ConnectToServerUseCase({required this.socketService});

  void call() {
    socketService.connectToServer();
  }
}
