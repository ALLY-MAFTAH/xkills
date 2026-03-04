import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '/views/auth/signin_page.dart';
import '/views/screens/tab_screen.dart';
import '/components/validations.dart';

import '../components/toasts.dart';
import '../constants/auth_user.dart';
import '../constants/endpoints.dart';
import '../enums/enums.dart';
import '../models/user.dart';
import '../services/http_service.dart';

class AuthController extends GetxController {
  bool isLoading = false;
  bool isSubmitting = false;
  bool isUploading = false;
  bool isForgotPassword = false;
  GetStorage storage = GetStorage();

  bool currentPasswordObscure = true;
  bool passwordObscure = true;
  bool newPasswordObscure = true;
  bool confirmPasswordObscure = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController resetCodeController = TextEditingController();

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final nameEditController = TextEditingController();
  final phoneEditController = TextEditingController();
  final emailEditController = TextEditingController();
  final addressEditController = TextEditingController();

  XFile? selectedProfileImage;

  int? temporaryUserId;
  String? temporaryUserToken;
  String? temporaryUsername;
  String? phoneForOTP;
  late GoogleSignIn _googleSignIn;

  @override
  void onInit() {
    super.onInit();
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    _googleSignIn = GoogleSignIn.instance;

    await _googleSignIn.initialize(
      clientId: dotenv.env["GOOGLE_CLIENT_ID"],
      serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      isSubmitting = true;
      update();

      // Use nullable type
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      if (idToken == null) {
        errorToast("Google authentication failed");
        return;
      }

      // Send ID token to backend
      final responseData = await HttpService.sendHttpRequest(
        "GOOGLE SIGN IN ENDPOINT :::",
        RequestType.POST,
        Endpoints.googleLogin,
        {"token": idToken},
        isAuthRequest: false,
      );

      if (responseData == null) return;

      String userToken = responseData['token'];
      User authUser = User.fromJson(responseData['user']);

      storage.write("userToken", userToken);
      Auth().saveAuthUser(authUser);

      clearFields();
      Get.offAll(() => TabsScreen());
    } on GoogleSignInException catch (e) {
      print("GoogleSignInException: $e");
      errorToast("Google Sign-In Failed");
    } catch (e) {
      print("EXCEPTION::::: Google Sign-In Failed");
      print(e.toString());
      errorToast("Google Sign-In Failed");
    } finally {
      isSubmitting = false;
      update();
    }
  }

  // LANGUAGE
  void changeLanguage(bool value) async {
    final storage = GetStorage();
    storage.write('isSwahili', value);

    Locale locale;
    if (value) {
      locale = const Locale('sw', 'TZ');
      storage.write("locale", "sw");
    } else {
      locale = const Locale('en', 'US');
      storage.write("locale", "en");
    }
    Get.updateLocale(locale);
  }

  // LOGIN
  Future<void> signin() async {
    isSubmitting = true;
    update();
    try {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      final responseData = await HttpService.sendHttpRequest(
        "SIGN IN ENDPOINT :::",
        RequestType.POST,
        Endpoints.login,
        {"email": convertToInternationalFormat(email), "password": password},
        isAuthRequest: false,
      );
      if (responseData == null) return;

      String message = responseData['message'];
      String userToken = responseData['token'];
      print(message);
      print(userToken);
      User authUser = User.fromJson(responseData['user']);
      storage.write("userToken", userToken);
      Auth().saveAuthUser(authUser);
      isSubmitting = false;
      clearFields();
      update();
      Get.offAll(() => TabsScreen());
    } catch (ex) {
      update();
      print(ex.toString());
      errorToast(ex.toString());
    } finally {
      passwordController.clear();
      isSubmitting = false;
      update();
    }
  }

  Future<void> signup() async {
    isSubmitting = true;
    update();

    try {
      String name = nameController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String confirmPassword = confirmPasswordController.text.trim();

      final responseData = await HttpService.sendHttpRequest(
        "SIGN UP ENDPOINT :::",
        RequestType.POST,
        Endpoints.signup,
        {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": confirmPassword,
        },
        isAuthRequest: false,
      );

      if (responseData == null) {
        errorToast("Signup failed");
        return;
      }
      if (responseData.containsKey('token')) {
        String userToken = responseData['token'];
        User authUser = User.fromJson(responseData['user']);

        storage.write("userToken", userToken);
        Auth().saveAuthUser(authUser);
      clearFields();

        Get.offAll(() => TabsScreen());
      } else {
        errorToast(responseData['message'] ?? "Signup failed");
      }
    } catch (ex) {
      print(ex.toString());
      errorToast(ex.toString());
    } finally {
      isSubmitting = false;
      update();
    }
  }

  // FORGOT PASSWORD
  Future<void> forgotPassword() async {
    isSubmitting = true;
    update();
    try {
      await Future.delayed(Duration(seconds: 1));
      String email = emailController.text.trim();

      final responseData = await HttpService.sendHttpRequest(
        "FORGOT PASSWORD ENDPOINT :::",
        RequestType.POST,
        Endpoints.forgotPassword,
        {"email": email},
        isAuthRequest: false,
      );
      if (responseData == null) return;

      String message = responseData['message'];
      bool succeeded = responseData['success'];
      print(message);
      if (succeeded) {
        successToast(message);
        clearFields();
        update();
        Get.offAll(() => SigninPage());
      }
    } catch (ex) {
      update();
      print(ex.toString());
      errorToast(ex.toString());
    } finally {
      isSubmitting = false;
      update();
    }
  }

  Future<void> getUserData() async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        "GET USER DATA ENDPOINT :::",

        RequestType.POST,
        Endpoints.getUserData,
        {"user_id": Auth().user!.id},
        isAuthRequest: false,
      );
      print(responseData);
      if (responseData == null) return;
      User authUser = User.fromJson(responseData['user']);
      Auth().saveAuthUser(authUser);
    } catch (e) {
      errorToast(e.toString());
    } finally {
      update();
    }
  }

  Future<void> updateProfile() async {
    isSubmitting = true;
    update();

    if (nameEditController.text.isEmpty || emailEditController.text.isEmpty) {
      errorToast("Email or Name Cannot be Empty".tr);
      isSubmitting = false;
      update();
      return;
    }
    try {
      final responseData = await HttpService.sendHttpRequest(
        "UPDATE PROFILE ENDPOINT :::",

        RequestType.POST,
        Endpoints.updateProfile,
        {
          "name": nameEditController.text.trim(),
          "phone": phoneEditController.text.trim(),
          "email": emailEditController.text.trim(),
          "address": addressEditController.text.trim(),
        },
        isAuthRequest: true,
      );

      if (responseData == null) return;

      User authUser = User.fromJson(responseData['user']);
      Auth().saveAuthUser(authUser);

      successToast("Profile Updated Successfully".tr);
    } catch (e) {
      errorToast(e.toString());
    } finally {
      isSubmitting = false;
      update();
    }
  }

  Future<void> updateProfilePhoto() async {
    isUploading = true;
    update();

    try {
      final responseData = await HttpService().sendMultipartRequest(
        url: Endpoints.updateProfile,
        file: selectedProfileImage,
        fields: {
          "name": Auth().user!.name!,
          "email": Auth().user!.email!,
          "phone": Auth().user!.phone!,
          "address": Auth().user!.address!,
        },
        method: RequestType.POST,
      );

      User authUser = User.fromJson(responseData['user']);
      Auth().saveAuthUser(authUser);

      successToast("Profile Photo Updated Successfully".tr);
    } catch (e) {
      errorToast(e.toString());
    } finally {
      isUploading = false;
      update();
    }
  }

  Future<void> changePassword() async {
    isLoading = true;
    update();
    try {
      String currentPassword = currentPasswordController.text.trim();
      String newPassword = newPasswordController.text.trim();
      String confirmPassword = confirmPasswordController.text.trim();
      if (confirmPassword != newPassword) {
        isLoading = false;
        update();
        errorToast("Passwords Do Not Match".tr);
      } else {
        await Future.delayed(Duration(seconds: 1));

        final responseData = await HttpService.sendHttpRequest(
          "CHANGE PASSWORD ENDPOINT :::",

          RequestType.POST,
          Endpoints.changePassword,
          {
            "current_password": currentPassword,
            "new_password": newPassword,
            "confirm_password": confirmPassword,
          },
        );
        if (responseData['status'] == "success") {
          currentPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();

          Get.back();
          successToast("Password Changed Successfully".tr);
        } else {
          errorToast(responseData['message'].toString());
        }
      }
    } catch (ex) {
      print(ex.toString());
      errorToast(ex.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  // Future<bool> isTokenStillAlive() async {
  //   final storage = GetStorage();
  //   final refreshToken = storage.read('refreshToken');
  //   try {
  //     final responseData = await HttpService.sendHttpRequest(
  //       RequestType.POST,
  //       Endpoints.refreshToken,
  //       {"refreshToken": refreshToken},
  //       false,
  //     );
  //           if (responseData == null) return false;

  //     print(responseData['message']);
  //     if (responseData['success'] == true) {
  //       print(responseData['data']);
  //       String userToken = responseData['data']['accesToken'];
  //       String refreshToken = responseData['data']['refreshToken'];

  //       storage.write("userToken", userToken);
  //       storage.write("refreshToken", refreshToken);
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (ex) {
  //     print(ex.toString());
  //     errorToast(ex.toString());
  //     return false;
  //   }
  // }

  // void logout() {
  //   final storage = GetStorage();
  //   storage.remove("authUser");
  //   storage.remove("userToken");
  //   storage.remove("refreshToken");

  //   Get.offAll(() => const LoginPage(), predicate: (route) => false);
  // }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    resetCodeController.clear();
  }
}
