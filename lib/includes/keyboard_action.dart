import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../components/slide_animations.dart';
import '../theme/app_colors.dart';

KeyboardActionsConfig buildKeyboardActionConfig(BuildContext context, FocusNode phoneFocusNode) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: AppColors.secondaryColor.withOpacity(.2),
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: phoneFocusNode,
          toolbarButtons: [
            (node) {
              return BottomTopSlide(
                child: GestureDetector(
                  onTap: () => node.unfocus(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12,
                    ),
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      "DONE".tr,
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ],
        ),
      ],
    );
  }