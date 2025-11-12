import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  static const routeName = '/login';
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final authController = Get.put(AuthController());

  @override
  void initState() {
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

            child: appBrand(),
          ),
          Form(
            key: loginFormKey,
            child: Center(
              child: SingleChildScrollView(
                child: GetBuilder<AuthController>(
                  builder: (authController) {
                    return Column(
                      children: [
                        const Center(
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 60,
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
                              fontWeight: FontWeight.bold,
                            ),
                            enabled: !authController.isSubmitting,
                            decoration: getInputDecoration('E-mail'),
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
                          height: 60,
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
                              fontWeight: FontWeight.bold,
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
                            decoration: getInputDecoration('Password'),
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
                                  fontSize: 14,
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
                                    fontSize: 14,
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
                                                "Email & password field cannot be empty",
                                              );
                                            } else if (authController
                                                .emailController
                                                .text
                                                .isEmpty) {
                                              errorToast(
                                                "Email field cannot be empty",
                                              );
                                            } else if (authController
                                                .passwordController
                                                .text
                                                .isEmpty) {
                                              errorToast(
                                                "Password field cannot be empty",
                                              );
                                            } else if (!isEmailValid(
                                              authController
                                                  .emailController
                                                  .text
                                                  .trim(),
                                            )) {
                                              errorToast("Email not valid");
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
                                                'Sign In',
                                                style: TextStyle(
                                                  fontSize: 16,
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't you have an account yet? ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
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
                                  ' Sign Up',
                                  style: TextStyle(
                                    color: AppColors.tertiaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
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
