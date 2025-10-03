// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import '/components/validations.dart';

// import '../components/toasts.dart';
// import '../constants/auth_user.dart';
// import '../constants/endpoints.dart';
// import '../enums/enums.dart';
// import '../models/user.dart';
// import '../services/http_service.dart';

// class AuthController extends GetxController {
//   bool isLoading = false;
//   bool isSubmitting = false;
//   bool isFirstLogin = false;
//   bool isForgotPassword = false;
//   GetStorage storage = GetStorage();

//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController resetCodeController = TextEditingController();

//   final TextEditingController oldPasswordController = TextEditingController();
//   final TextEditingController newPasswordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   bool usernameHasError = false;
//   bool passwordHasError = false;
//   bool resetCodeHasError = false;

//   bool oldPasswordHasError = false;
//   bool newPasswordHasError = false;
//   bool confirmPasswordHasError = false;

//   final FocusNode usernameFocusNode = FocusNode();
//   final FocusNode passwordFocusNode = FocusNode();
//   final FocusNode loginBtnFocusNode = FocusNode();
//   final FocusNode resetCodeFocusNode = FocusNode();

//   final FocusNode oldPasswordFocusNode = FocusNode();
//   final FocusNode newPasswordFocusNode = FocusNode();
//   final FocusNode confirmPasswordFocusNode = FocusNode();
//   final FocusNode changePasswordBtnFocusNode = FocusNode();

//   int? temporaryUserId;
//   String? temporaryUserToken;
//   String? temporaryUsername;
//   String? phoneForOTP;

//   // LOGIN
//   Future<void> login() async {
//     isSubmitting = true;
//     update();
//     try {
//       await Future.delayed(Duration(seconds: 1));
//       String username = usernameController.text.trim();
//       String password = passwordController.text.trim();

//       final responseData = await HttpService.sendHttpRequest(
//         RequestType.POST,
//         Endpoints.login,
//         {"phone": convertToInternationalFormat(username), "password": password},
//         false,
//         isAuthRequest: false,
//       );
//       if (responseData == null) return;

//       if (responseData['success'] == true) {
//         if (responseData['data']['isFirstLogin'] == true) {
//           temporaryUserId = responseData['data']['userId'];
//           temporaryUserToken = responseData['data']['token']['accesToken'];
//           temporaryUsername = usernameController.text.trim();
//           isFirstLogin = true;
//           isSubmitting = false;
//           update();
//           infoToast("default_password_msg".tr);
//           Get.to(const ChangePasswordScreen());
//         } else {
//           String userToken = responseData['data']['token']['accesToken'];
//           String refreshToken = responseData['data']['token']['refreshToken'];

//           User authUser = User.fromJson(responseData['data']);
//           storage.write("userToken", userToken);
//           storage.write("refreshToken", refreshToken);
//           Auth().saveAuthUser(authUser);

//           final masterController = Get.put(MasterController());
//           await masterController.setUserSchool(
//             responseData['data']['isSuperAdmin'],
//             responseData['data']['accountType'],
//             responseData['data']['userId'],
//             authUser,
//           );
//           await masterController.initializeAppData();

//           isSubmitting = false;
//           usernameController.clear();
//           update();

//           Get.offAll(
//             () => Auth().user!.isSuperAdmin! ? HomeScreen() : MasterPage(),
//           );
//           successToast("success_login".tr);
//         }
//       } else if (responseData['message'] == "Phone does not exist" ||
//           responseData['message'] == "Incorrect Phone or Password") {
//         isSubmitting = false;
//         update();
//         errorToast("invalid_credentials".tr);
//       } else {
//         isSubmitting = false;
//         update();
//         errorToast(responseData['message'].toString());
//       }
//     } catch (ex) {
//       isSubmitting = false;
//       update();
//       print(ex.toString());
//       errorToast(ex.toString());
//     } finally {
//       passwordController.clear();
//       update();
//     }
//   }

//   Future<void> requestResetCode() async {
//     isSubmitting = true;
//     update();
//     try {
//       await Future.delayed(Duration(seconds: 1));
//       String username = usernameController.text.trim();

//       final responseData = await HttpService.sendHttpRequest(
//         RequestType.POST,
//         Endpoints.requestResetCode,
//         {"phoneNumber": convertToInternationalFormat(username)},
//         false,
//         isAuthRequest: false,
//       );
//       if (responseData == null) return;

//       if (responseData['success'] == true) {
//         String resetCode = responseData['data']['otp'];
//         phoneForOTP = responseData['data']['phone'];
//         temporaryUserId = responseData['data']['userId'];
//         String reference = SmsService().generateReference(
//           "${temporaryUserId}_$temporaryUserId",
//         );
//         final appSignature = await SmsAutoFill().getAppSignature;

//         SmsService().sendSms(
//           to: phoneForOTP!,
//           message: "<#> Your reset code is: $resetCode \n$appSignature",
//           reference: reference,
//         );

//         isSubmitting = false;
//         usernameController.clear();
//         update();

//         Get.offAll(() => ResetCodeScreen());
//         successToast("reset_code_sent".tr);
//       } else if (responseData['message'] == "Phone does not exist" ||
//           responseData['message'] == "Incorrect Phone or Password") {
//         isSubmitting = false;
//         update();
//         errorToast("phone_not_exist".tr);
//       } else {
//         isSubmitting = false;
//         update();
//         errorToast(responseData['message'].toString());
//       }
//     } catch (ex) {
//       isSubmitting = false;
//       update();
//       print(ex.toString());
//       errorToast(ex.toString());
//     } finally {
//       update();
//     }
//   }

//   Future<void> changeDefaultPassword() async {
//     isSubmitting = true;
//     update();
//     try {
//       if (confirmPasswordController.text != newPasswordController.text) {
//         confirmPasswordHasError = true;
//         isSubmitting = false;
//         update();
//         errorToast("passwords_not_match".tr);
//       } else {
//         confirmPasswordHasError = false;
//         await Future.delayed(Duration(seconds: 1));
//         String newPassword = newPasswordController.text.trim();
//         final responseData = await HttpService.sendHttpRequest(
//           RequestType.POST,
//           Endpoints.changeDefaultPassword,
//           {"userId": temporaryUserId, "newPassword": newPassword},
//           true,
//         );
//         if (responseData == null) return;

//         if (responseData['success'] == true) {
//           print(responseData['data']);
//           clearFields();
//           isSubmitting = false;
//           isFirstLogin = false;
//           temporaryUserToken = "";
//           temporaryUsername = "";
//           temporaryUserId = 0;
//           successToast("pass_change_success".tr);
//           isForgotPassword=false;
//           Get.offAll(() => const LoginScreen(), predicate: (route) => false);
//         } else {
//           isSubmitting = false;
//           update();
//           errorToast(responseData['message'].toString());
//         }
//       }
//     } catch (ex) {
//       isSubmitting = false;
//       update();
//       print(ex.toString());
//       errorToast(ex.toString());
//     } finally {
//       isSubmitting = false;
//       update();
//     }
//   }

//   Future<void> verifyResetCode() async {
//     isSubmitting = true;
//     update();
//     try {
//       await Future.delayed(Duration(seconds: 1));
//       final responseData = await HttpService.sendHttpRequest(
//         RequestType.POST,
//         Endpoints.verifyResetCode,
//         {"phoneNumber": phoneForOTP!, "otp": resetCodeController.text.trim()},
//         true,
//       );
//       if (responseData == null) return;

//       if (responseData['success'] == true) {
//         print(responseData['data']);
//         // clearFields();
//         isSubmitting = false;
//         update();
//         successToast("otp_verified".tr);
//         isFirstLogin = true;
//         update();
//         Get.offAll(() => const ChangePasswordScreen());
//       } else {
//         isSubmitting = false;
//         update();
//         errorToast(responseData['message'].toString());
//       }
//     } catch (ex) {
//       isSubmitting = false;
//       update();
//       print(ex.toString());
//       errorToast(ex.toString());
//     } finally {
//       isSubmitting = false;
//       update();
//     }
//   }

//   Future<void> changePassword() async {
//     isSubmitting = true;
//     update();
//     try {
//       if (confirmPasswordController.text != newPasswordController.text) {
//         confirmPasswordHasError = true;
//         isSubmitting = false;
//         update();
//         errorToast("passwords_not_match".tr);
//       } else {
//         confirmPasswordHasError = false;
//         await Future.delayed(Duration(seconds: 1));
//         int staffId = Auth().user!.id!;
//         String oldPassword = oldPasswordController.text.trim();
//         String newPassword = newPasswordController.text.trim();
//         final responseData = await HttpService.sendHttpRequest(
//           RequestType.PATCH,
//           Endpoints.changePassword,
//           {
//             "staffid": staffId,
//             "staffpassword": newPassword,
//             "oldpassword": oldPassword,
//           },
//           false,
//         );
//         print(responseData['message']);
//         if (responseData['success'] == true) {
//           print(responseData['data']);
//           oldPasswordController.clear();
//           newPasswordController.clear();
//           confirmPasswordController.clear();
//           isSubmitting = false;
//           update();
//           Get.back();
//           successToast("pass_change_success".tr);
//         } else {
//           isSubmitting = false;
//           update();
//           errorToast(responseData['message'].toString());
//         }
//       }
//     } catch (ex) {
//       isSubmitting = false;
//       update();
//       print(ex.toString());
//       errorToast(ex.toString());
//     } finally {
//       isSubmitting = false;
//       update();
//     }
//   }

//   Future<bool> isTokenStillAlive() async {
//     final storage = GetStorage();
//     final refreshToken = storage.read('refreshToken');
//     try {
//       final responseData = await HttpService.sendHttpRequest(
//         RequestType.POST,
//         Endpoints.refreshToken,
//         {"refreshToken": refreshToken},
//         false,
//       );
//             if (responseData == null) return false;

//       print(responseData['message']);
//       if (responseData['success'] == true) {
//         print(responseData['data']);
//         String userToken = responseData['data']['accesToken'];
//         String refreshToken = responseData['data']['refreshToken'];

//         storage.write("userToken", userToken);
//         storage.write("refreshToken", refreshToken);
//         return true;
//       } else {
//         return false;
//       }
//     } catch (ex) {
//       print(ex.toString());
//       errorToast(ex.toString());
//       return false;
//     }
//   }

//   void logout() {
//     final storage = GetStorage();
//     storage.remove("authUser");
//     storage.remove("userToken");
//     storage.remove("refreshToken");

//     Get.offAll(() => const LoginScreen(), predicate: (route) => false);
//   }

//   void clearFields() {
//     usernameController.clear();
//     passwordController.clear();
//     oldPasswordController.clear();
//     newPasswordController.clear();
//     confirmPasswordController.clear();
//     resetCodeController.clear();
//     resetCodeFocusNode.unfocus();
//     passwordFocusNode.unfocus();
//     usernameFocusNode.unfocus();
//     usernameHasError = false;
//     passwordHasError = false;
//     oldPasswordHasError = false;
//     newPasswordHasError = false;
//     confirmPasswordHasError = false;
//   }

//   @override
//   void onInit() {
//     super.onInit();
//   }
// }
