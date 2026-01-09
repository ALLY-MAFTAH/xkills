// ignore_for_file: must_be_immutable

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '/theme/app_colors.dart';
import '/enums/enums.dart';
import '../validations.dart';

class InputFormField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final bool isRequired;
  final bool enabled;
  bool obscure;
  final String autoFillHints;
  bool fieldHasError;
  final VoidCallback onFieldSubmitted;
  final Function onChanged;
  final String labelText;
  final String hintText;
  final String errorMsg;
  final InputType inputType;
  InputFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.nextFocusNode,
    required this.labelText,
    required this.hintText,
    required this.errorMsg,
    required this.enabled,
    required this.obscure,
    required this.autoFillHints,
    required this.fieldHasError,
    required this.onFieldSubmitted,
    required this.onChanged,
    required this.isRequired,
    required this.inputType,
  });

  @override
  State<InputFormField> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends State<InputFormField> {
  String? fileName;

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          widget.inputType == InputType.file
              ? GestureDetector(
                onTap: widget.enabled ? _pickFile : null,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    hintText: widget.hintText,
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 10,
                    ),
                    suffixIcon: Icon(Icons.attach_file),
                  ),
                  child: Text(
                    fileName ?? widget.hintText,
                    style: TextStyle(
                      color: fileName != null ? Colors.black87 : Colors.grey[400],
                    ),
                  ),
                ),
              )
              : KeyboardListener(
                focusNode:
                    widget.inputType == InputType.multiLines
                        ? FocusNode()
                        : FocusNode(
                          onKeyEvent: (node, event) {
                            if (HardwareKeyboard.instance.isLogicalKeyPressed(
                              LogicalKeyboardKey.enter,
                            )) {
                              if (HardwareKeyboard.instance.isShiftPressed) {
                                widget.controller.text += "\n";
                                widget
                                    .controller
                                    .selection = TextSelection.fromPosition(
                                  TextPosition(
                                    offset: widget.controller.text.length,
                                  ),
                                );
                              } else {
                                FocusScope.of(
                                  context,
                                ).requestFocus(widget.nextFocusNode);
                              }
                              return KeyEventResult.handled;
                            }
                            return KeyEventResult.ignored;
                          },
                        ),
                onKeyEvent:
                    widget.inputType == InputType.multiLines
                        ? null
                        : (event) {
                          if (HardwareKeyboard.instance.isLogicalKeyPressed(
                                LogicalKeyboardKey.enter,
                              ) &&
                              !HardwareKeyboard.instance.isShiftPressed) {
                            FocusScope.of(
                              context,
                            ).requestFocus(widget.nextFocusNode);
                          }
                        },
                child: TextFormField(
                  autofillHints: [widget.autoFillHints],
                  controller: widget.controller,
                  keyboardType:
                      widget.inputType == InputType.email
                          ? TextInputType.emailAddress
                          : widget.inputType == InputType.number ||
                              widget.inputType == InputType.NIDA ||
                              widget.inputType == InputType.phone
                          ? TextInputType.number
                          : widget.inputType == InputType.password
                          ? TextInputType.visiblePassword
                          : TextInputType.text,
                  autovalidateMode: AutovalidateMode.disabled,
                  obscureText: widget.obscure,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    labelText: widget.labelText,
                    hintStyle:  TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[400],
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabled: widget.enabled,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    suffixIcon:
                        widget.inputType != InputType.password
                            ? null
                            : IconButton(
                              icon:
                                  widget.obscure
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  widget.obscure = !widget.obscure;
                                });
                              },
                            ),
                  ),
                  textInputAction: TextInputAction.next,
                  focusNode: widget.focusNode,
                  onFieldSubmitted: (value) {
                    widget.onFieldSubmitted();
                  },
                  // 
                  validator: (value) {
                    if (widget.isRequired) {
                      if (value == null || value.isEmpty) {
                        widget.fieldHasError = true;
                        return widget.errorMsg;
                      } else {
                        widget.fieldHasError = false;
                      }

                      if (widget.inputType == InputType.email &&
                          !isEmailValid(value)) {
                        widget.fieldHasError = true;
                        return 'Invalid Email'.tr; // me@domain.com
                      }

                      if (widget.inputType == InputType.phone &&
                          !isShortPhoneNumberValid(value)) {
                        widget.fieldHasError = true;
                        return 'Invalid Phone'.tr;
                      }

                      if (widget.inputType == InputType.NIDA &&
                          !isNidaValid(value)) {
                        widget.fieldHasError = true;
                        return 'Invalid Nida'.tr; // 20 digits
                      }
                    }

                    return null;
                  },
                ),
              ),
    );
  }

Future<void> _pickFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        fileName = file.name;
      });

      final text = file.path ?? '';
      widget.controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );

      widget.onChanged(text);
    }
  } catch (e) {
    print('Error picking file: $e');
  }
}

}
