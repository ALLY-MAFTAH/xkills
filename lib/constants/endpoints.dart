import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  static String baseUrl = dotenv.env['BASE_URL']!;

  // Auth
  static String login = dotenv.env['LOGIN']!;
  static String signup = dotenv.env['SIGNUP']!;
  static String changePassowrd = dotenv.env['CHANGE_PASSWORD']!;
  static String forgotPassowrd = dotenv.env['FORGOT_PASSWORD']!;
  // Categories
  static String getCategories = dotenv.env['GET_CATEGORIES']!;
  // Courses
  static String getCourses = dotenv.env['GET_COURSES']!;
  static String getMyCourses = dotenv.env['GET_MY_COURSES']!;
  // Sections
  static String getSections = dotenv.env['GET_SECTIONS']!;
  static String getCartList = dotenv.env['CART_LIST']!;
  static String addOrRemoveCart = dotenv.env['TOGGLE_CART_ITEMS']!;
  static String updateWatchHistory = dotenv.env['UPDATE_WATCH_HISTORY']!;
}
