import 'package:logger/logger.dart';

Logger initLogger() {
  return Logger(
    printer: PrettyPrinter(),
  );
}
