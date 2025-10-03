import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  static String baseUrl = dotenv.env['BASE_URL']!;

  // Auth
  static String login = dotenv.env['LOGIN']!;
}
