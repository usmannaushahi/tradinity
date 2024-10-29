import 'package:flutter_dotenv/flutter_dotenv.dart';

String kGetAPIKEY() {
  return dotenv.env['API_KEY'] ?? "";
}

