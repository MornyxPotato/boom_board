import 'package:boom_board/core/exceptions/invalid_socket_response_exception.dart';

enum GameMode {
  simple
  ;

  static GameMode fromString(String value) {
    switch (value) {
      case 'simple':
        return simple;
      default:
        throw InvalidSocketResponseException();
    }
  }

  @override
  String toString() {
    switch (this) {
      case simple:
        return 'simple';
    }
  }
}
