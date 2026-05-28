import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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
    try {
      await _googleSignIn.initialize(
        clientId: dotenv.env["GOOGLE_CLIENT_ID"],
        serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
      );
    } catch (e, st) {
      debugPrint('GoogleSignIn initialize failed: $e\n$st');
    }
  }

  Future<void> signInWithGoogle() async {
    // Prevent concurrent calls
    if (isSubmitting) return;

    try {
      isSubmitting = true;
      update();

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
      // User canceled — do not show error toast for cancellation
      if (e.code != GoogleSignInExceptionCode.canceled) {
        errorToast("Google Sign-In Failed. Please try again.");
      }
      debugPrint("GoogleSignInException: $e");
    } catch (e) {
      debugPrint("Google Sign-In error: $e");
      errorToast("Google Sign-In Failed. Please try again.");
    } finally {
      isSubmitting = false;
      update();
    }
  }

  Future<void> signInWithApple() async {
    if (isSubmitting) return;
    try {
      isSubmitting = true;
      update();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = credential.identityToken;
      if (identityToken == null || identityToken.isEmpty) {
        errorToast("Apple authentication failed");
        return;
      }

      final responseData = await HttpService.sendHttpRequest(
        "APPLE SIGN IN ENDPOINT :::",
        RequestType.POST,
        Endpoints.appleLogin,
        {"token": identityToken},
        isAuthRequest: false,
      );

      if (responseData == null) return;

      final String userToken = responseData['token'];
      final User authUser = User.fromJson(responseData['user']);

      storage.write("userToken", userToken);
      Auth().saveAuthUser(authUser);

      clearFields();
      Get.offAll(() => TabsScreen());
    } on SignInWithAppleAuthorizationException catch (e, st) {
      // User cancelled -> no toast
      if (e.code != AuthorizationErrorCode.canceled) {
        debugPrint('Apple sign-in error: $e\n$st');
        errorToast("Apple Sign-In Failed. Please try again.");
      }
    } catch (e, st) {
      debugPrint('Apple sign-in error: $e\n$st');
      errorToast("Apple Sign-In Failed. Please try again.");
    } finally {
      isSubmitting = false;
      update();
    }
  }

  Future<void> deleteAccount() async {
    if (isSubmitting) return;
    final dynamic rawToken = storage.read('userToken');
    final String token = rawToken?.toString().trim() ?? '';
    if (token.isEmpty || token == 'null') {
      errorToast('session_expired_sign_in_again'.tr);
      Get.offAll(() => const SigninPage());
      return;
    }
    try {
      isSubmitting = true;
      update();

      final responseData = await HttpService.sendHttpRequest(
        "DELETE ACCOUNT ENDPOINT :::",
        RequestType.POST,
        Endpoints.deleteAccount,
        {},
        isAuthRequest: true,
      );

      final succeeded = responseData is Map &&
          (responseData['success'] == true ||
              responseData['success'] == 1 ||
              responseData['success'] == 'true');

      if (succeeded) {
        final storage = GetStorage();
        storage.erase();
        successToast("Account deleted successfully".tr);
        Get.offAll(() => const SigninPage());
      } else {
        errorToast((responseData['message'] ?? 'Could not delete account').toString());
      }
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('Unauthenticated')) {
        errorToast('session_expired_sign_in_again'.tr);
        storage.erase();
        Get.offAll(() => const SigninPage());
      } else {
        errorToast(msg);
      }
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

      final message =
          responseData['message']?.toString() ?? 'Request completed';
      final succeeded = responseData['success'] == true ||
          responseData['success'] == 1 ||
          responseData['success'] == 'true';
      if (succeeded) {
        successToast(message);
        clearFields();
        update();
        Get.offAll(() => SigninPage());
      } else {
        errorToast(message);
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
        {},
        isAuthRequest: true,
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
