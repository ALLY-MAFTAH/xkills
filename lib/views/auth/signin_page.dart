import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/views/auth/forgot_password_page.dart';
import '../../includes/auth_inputs_decoration.dart';
import '/components/toasts.dart';
import '/components/validations.dart';
import '/components/custom_loader.dart';
import '/constants/app_brand.dart';
import '/controllers/auth_controller.dart';

import '../../theme/app_colors.dart';
import 'signup_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final authController = Get.put(AuthController());
  bool isSwahili = false;
  final storage = GetStorage();

  @override
  void initState() {
    isSwahili = storage.read('isSwahili') ?? false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.secondaryColor, AppColors.primaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          Positioned(
            top:
                Platform.isAndroid
                    ? MediaQuery.of(context).padding.top + 15
                    : MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,

            child: appLogo(),
          ),
          Form(
            key: loginFormKey,
            child: Center(
              child: SingleChildScrollView(
                child: GetBuilder<AuthController>(
                  builder: (authController) {
                    return Column(
                      children: [
                        Center(
                          child: Text(
                            'Sign In'.tr,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          child: TextFormField(
                            style: TextStyle(
                              color:
                                  authController.isSubmitting
                                      ? Colors.grey[700]
                                      : Colors.white,
                              fontSize: 12,
                            ),
                            enabled: !authController.isSubmitting,
                            decoration: getInputDecoration(
                              authController,
                              'E-mail',
                              () {},
                            ),
                            cursorColor: Colors.white,
                            controller: authController.emailController,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              setState(() {
                                authController.emailController.text =
                                    value as String;
                              });
                            },
                          ),
                        ),
                        Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          child: TextFormField(
                            style: TextStyle(
                              color:
                                  authController.isSubmitting
                                      ? Colors.grey[700]
                                      : Colors.white,
                              fontSize: 12,
                            ),
                            enabled: !authController.isSubmitting,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.white,
                            controller: authController.passwordController,
                            onSaved: (input) {
                              setState(() {
                                authController.passwordController.text =
                                    input as String;
                              });
                            },
                            obscureText: authController.passwordObscure,
                            decoration: getInputDecoration(
                              authController,
                              'Password',
                              () {
                                setState(() {
                                  authController.passwordObscure =
                                      !authController.passwordObscure;
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 15,
                            top: 5,
                            bottom: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Forgot password? ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  ' Reset',
                                  style: TextStyle(
                                    color: AppColors.tertiaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Center(
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.primaryColor,
                                          AppColors.secondaryColor,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed:
                                      authController.isSubmitting
                                          ? null
                                          : () {
                                            if (authController
                                                    .emailController
                                                    .text
                                                    .isEmpty &&
                                                authController
                                                    .passwordController
                                                    .text
                                                    .isEmpty) {
                                              errorToast(
                                                "Email & Password Field Cannot Be Empty"
                                                    .tr,
                                              );
                                            } else if (authController
                                                .emailController
                                                .text
                                                .isEmpty) {
                                              errorToast(
                                                "Email Field Cannot Be Empty"
                                                    .tr,
                                              );
                                            } else if (authController
                                                .passwordController
                                                .text
                                                .isEmpty) {
                                              errorToast(
                                                "Password Field Cannot Be Empty"
                                                    .tr,
                                              );
                                            } else if (!isEmailValid(
                                              authController
                                                  .emailController
                                                  .text
                                                  .trim(),
                                            )) {
                                              errorToast("Email Not Valid".tr);
                                            } else {
                                              setState(() {
                                                authController.signin();
                                              });
                                            }
                                          },
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 13,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(10),
                                    side: BorderSide.none,
                                  ),
                                  child:
                                      authController.isSubmitting
                                          ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [customLoader()],
                                          )
                                          : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Sign In'.tr,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: OutlinedButton.icon(
                            onPressed:
                                authController.isSubmitting
                                    ? null
                                    : () {
                                      authController.signInWithGoogle();
                                    },
                            icon: Image.asset(
                              'assets/images/google_logo.png',
                              height: 20,
                            ),
                            label: Text(
                              "Continue With Google".tr,
                              style: TextStyle(color: Colors.white),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white, width: 1),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't You Have An Account Yet? ".tr,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SignupPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  ' Sign Up'.tr,
                                  style: TextStyle(
                                    color: AppColors.tertiaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${"Language".tr}: ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isSwahili = false;
                                  });
                                  authController.changeLanguage(false);
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      '🇬🇧 ${"EN".tr}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none,
                                        color:
                                            !isSwahili
                                                ? Colors.white
                                                : Colors.grey,
                                      ),
                                    ),
                                    if (!isSwahili)
                                      Positioned(
                                        bottom: -3,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 4,
                                          color: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10, child: Text("|")),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isSwahili = true;
                                  });
                                  authController.changeLanguage(true);
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      '🇹🇿 ${"SW".tr}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none,
                                        color:
                                            isSwahili
                                                ? Colors.white
                                                : Colors.grey,
                                      ),
                                    ),
                                    if (isSwahili)
                                      Positioned(
                                        bottom: -3,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 4,
                                          color: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
