import 'package:flutter_dotenv/flutter_dotenv.dart';

String get backendUrl {
  return dotenv.get('BACKEND_URL');
}
