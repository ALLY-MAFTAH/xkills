import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  static String baseUrl = dotenv.env['BASE_URL']!;
  static String apiKey = dotenv.env['API_KEY']!;

  // Auth
  static String login = dotenv.env['LOGIN']!;
  static String signup = dotenv.env['SIGNUP']!;
  static String googleLogin = dotenv.env['GOOGLE_LOGIN']!;
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
  static String getSavedCourses = dotenv.env['MY_WISH_LIST']!;
  static String addOrRemoveSavedCourse = dotenv.env['TOGGLE_WISHLIST_ITEMS']!;
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
  static String storeCourseRate = dotenv.env['STORE_COURSE_RATE']!;
  static String updateWatchHistory = dotenv.env['UPDATE_WATCH_HISTORY']!;
  static String checkPaymentStatus = dotenv.env['CHECK_PAYMENT_STATUS']!;
  static String zenoWebhook = dotenv.env['ZENO_WEBHOOK']!;
  static String recordPayment = dotenv.env['RECORD_PAYMENT']!;
}
