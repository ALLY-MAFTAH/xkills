import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/components/toasts.dart';
import '/components/validations.dart';
import '../../components/custom_loader.dart';
import '../../constants/app_brand.dart';
import '../../includes/auth_inputs_decoration.dart';
import '/controllers/auth_controller.dart';

import '../../theme/app_colors.dart';

class SignupPage extends StatefulWidget {
  static const routeName = '/signup';
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
            left: 10,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.arrow_back,
                  size: 28,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
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
                            'Sign Up',
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
                            decoration: getInputDecoration('Full Name', () {}),
                            cursorColor: Colors.white,
                            controller: authController.nameController,
                            keyboardType: TextInputType.name,
                            onSaved: (value) {
                              setState(() {
                                authController.nameController.text =
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
                            decoration: getInputDecoration('E-mail', () {}),
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
                            decoration: getInputDecoration('Password', () {
                              setState(() {
                                authController.passwordObscure =
                                    !authController.passwordObscure;
                              });
                            }),
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
                            controller:
                                authController.confirmPasswordController,
                            onSaved: (input) {
                              setState(() {
                                authController.confirmPasswordController.text =
                                    input as String;
                              });
                            },
                            obscureText: authController.confirmPasswordObscure,
                            decoration: getInputDecoration(
                              'Confirm Password',
                              () {
                                setState(() {
                                  authController.confirmPasswordObscure =
                                      !authController.confirmPasswordObscure;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
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
                                                .nameController
                                                .text
                                                .isEmpty) {
                                              errorToast(
                                                "Full name field cannot be empty",
                                              );
                                            } else if (authController
                                                .emailController
                                                .text
                                                .isEmpty) {
                                              errorToast(
                                                "Email field cannot be empty",
                                              );
                                            } else if (!isEmailValid(
                                              authController
                                                  .emailController
                                                  .text
                                                  .trim(),
                                            )) {
                                              errorToast("Email not valid");
                                            } else if (authController
                                                .passwordController
                                                .text
                                                .isEmpty) {
                                              errorToast(
                                                "Password field cannot be empty",
                                              );
                                            } else if (authController
                                                .confirmPasswordController
                                                .text
                                                .isEmpty) {
                                              errorToast(
                                                "Confirm password field cannot be empty",
                                              );
                                            } else if (authController
                                                    .passwordController
                                                    .text
                                                    .trim() !=
                                                authController
                                                    .confirmPasswordController
                                                    .text
                                                    .trim()) {
                                              errorToast(
                                                "Passwords do not match",
                                              );
                                            } else {
                                              setState(() {
                                                authController.signup();
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
                                                'Sign Up',
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
                                "Already have an account? ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  ' Sign In',
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
