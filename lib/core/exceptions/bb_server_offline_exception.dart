import 'package:boom_board/core/exceptions/bb_server_exception.dart';

class BbServerOfflineException extends BBServerException {
  BbServerOfflineException({required super.code, required super.errorType, super.data});
}
