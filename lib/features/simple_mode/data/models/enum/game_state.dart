import 'package:boom_board/core/exceptions/invalid_socket_response_exception.dart';

enum GameState {
  lobby,
  position,
  attack,
  process,
  end
  ;

  static GameState fromString(String value) {
    switch (value) {
      case 'lobby':
        return lobby;
      case 'position':
        return position;
      case 'attack':
        return attack;
      case 'process':
        return process;
      case 'end':
        return end;
      default:
        throw InvalidSocketResponseException();
    }
  }

  @override
  String toString() {
    switch (this) {
      case GameState.lobby:
        return 'lobby';
      case GameState.position:
        return 'position';
      case GameState.attack:
        return 'attack';
      case GameState.process:
        return 'process';
      case GameState.end:
        return 'end';
    }
  }
}
