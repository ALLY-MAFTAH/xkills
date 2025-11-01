import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:skillsbank/components/toasts.dart';
import 'package:skillsbank/components/validations.dart';
import '../../components/custom_loader.dart';
import '../../constants/app_brand.dart';
import '/controllers/auth_controller.dart';

import '../../theme/app_colors.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool obscure = true;

  final authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
  }

  InputDecoration getInputDecoration(String hintext) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: AppColors.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: AppColors.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: AppColors.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      filled: true,
      hintStyle: TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      hintText: hintext,
      fillColor: Colors.white.withOpacity(.1),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      suffixIcon:
          hintext == "Password"
              ? IconButton(
                onPressed: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
                color: Colors.white,
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              )
              : null,
    );
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
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(),
                      height: 70,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
                      decoration: BoxDecoration(),
                      height: 70,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.white,
                        controller: authController.passwordController,
                        onSaved: (input) {
                          setState(() {
                            authController.passwordController.text =
                                input as String;
                          });
                        },

                        obscureText: obscure,
                        decoration: getInputDecoration('Password'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15, bottom: 10),
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
                              print("object");
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
                    GetBuilder<AuthController>(
                      builder: (authController) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                          stops: [0.05, 0.88],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
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
                                                    .text,
                                              )) {
                                                errorToast("Email not valid");
                                              } else {
                                                authController.login();
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
                                            ? Row(mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                customLoader(),
                                              ],
                                            )
                                            : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Log In',
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
                        );
                      },
                    ),

                    const SizedBox(height: 30),
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
                            onTap: () {},
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
