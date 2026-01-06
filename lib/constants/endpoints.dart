import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  static String baseUrl = dotenv.env['BASE_URL']!;
  static String apiKey = dotenv.env['API_KEY']!;

  // Auth
  static String login = dotenv.env['LOGIN']!;
  static String signup = dotenv.env['SIGNUP']!;
  static String changePassword = dotenv.env['CHANGE_PASSWORD']!;
  static String forgotPassword = dotenv.env['FORGOT_PASSWORD']!;
  static String getUserData = dotenv.env['GET_USER_DATA']!;
  static String updateProfile = dotenv.env['UPDATE_USER_DATA']!;
  // Categories
  static String getCategories = dotenv.env['GET_CATEGORIES']!;
  static String getSubCategories = dotenv.env['GET_SUB_CATEGORIES']!;
  // Categories
  static String getInstructors = dotenv.env['GET_INSTRUCTORS']!;
  static String getAllPacks = dotenv.env['GET_ALL_PACKS']!;
  static String getOtherPacks = dotenv.env['GET_OTHER_PACKS']!;
  static String getMyPacks = dotenv.env['GET_MY_PACKS']!;
  // Courses
  static String getTopCourses = dotenv.env['GET_TOP_COURSES']!;
  static String getAllCourses = dotenv.env['GET_ALL_COURSES']!;
  static String getOtherCourses = dotenv.env['GET_OTHER_COURSES']!;
  static String getMyCourses = dotenv.env['GET_MY_COURSES']!;
  static String freeCourseEnroll = dotenv.env['FREE_COURSE_ENROLL']!;
  static String getCoursesByInstructor = dotenv.env['GET_COURSES_BY_INSTRUCTOR']!;
  // Sections
  static String getSections = dotenv.env['GET_SECTIONS']!;
  static String getCartList = dotenv.env['CART_LIST']!;
  static String addOrRemoveCart = dotenv.env['TOGGLE_CART_ITEMS']!;
  static String updateWatchHistory = dotenv.env['UPDATE_WATCH_HISTORY']!;
}
