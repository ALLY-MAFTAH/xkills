import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';

InputDecoration getInputDecoration(
  AuthController authController,
  String hintext,
  VoidCallback toggleObscure,
) {
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
    filled: true,
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
    hintText: hintext,
    fillColor:
        authController.isSubmitting
            ? Colors.white.withOpacity(.05)
            : Colors.white.withOpacity(.1),
    contentPadding: const EdgeInsets.all(15),

    suffixIcon:
        hintext.contains("Password")
            ? IconButton(
              onPressed: authController.isSubmitting ? null : toggleObscure,
              color: Colors.white,
              icon: Icon(_getIcon(authController, hintext)),
            )
            : null,
  );
}

IconData _getIcon(AuthController c, String hint) {
  if (hint == "Current Password") {
    return c.currentPasswordObscure
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;
  } else if (hint == "New Password") {
    return c.newPasswordObscure
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;
  } else {
    return c.confirmPasswordObscure
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;
  }
}
