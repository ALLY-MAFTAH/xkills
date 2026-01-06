import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

InputDecoration getInputDecoration(String hintext, VoidCallback toggleObscure) {


  final authController = Get.put(AuthController());
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none,
    ),
    border: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none,
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none,
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none,
    ),
    filled: true,
    hintStyle: TextStyle(
      color: Colors.grey,
      fontSize: 12,
    ),
    hintText: hintext,
    fillColor:
        authController.isSubmitting
            ? Colors.white.withOpacity(.05)
            : Colors.white.withOpacity(.1),
    contentPadding: const EdgeInsets.all(15),
    suffixIcon:
        hintext == "Password" || hintext == "Confirm Password"
            ? IconButton(
              onPressed:
                  authController.isSubmitting
                      ? null
                      : () {
                        toggleObscure();
                      },
              disabledColor: Colors.grey[700],
              color: Colors.white,
              icon:
                  hintext == "Password"
                      ? Icon(
                        authController.passwordObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      )
                      : Icon(
                        authController.confirmPasswordObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
            )
            : null,
  );
}
