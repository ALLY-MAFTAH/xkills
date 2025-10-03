// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/theme/app_colors.dart';

class DateFormField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final bool isRequired;
  bool fieldHasError;
  final VoidCallback onFieldSubmitted;
  VoidCallback? onChanged;
  final String labelText;
  final String hintText;
  final String errorMsg;
  final bool enabled;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  DateFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.nextFocusNode,
    required this.labelText,
    required this.hintText,
    required this.errorMsg,
    required this.fieldHasError,
    required this.onFieldSubmitted,
    this.onChanged,
    required this.isRequired,
    required this.enabled,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<DateFormField> createState() => DateFormFieldState();
}

class DateFormFieldState extends State<DateFormField> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      selectedDate = widget.initialDate;
      widget.controller.text = DateFormat(
        'EEEE, d MMMM yyyy',
      ).format(selectedDate!);
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime minDate = widget.firstDate ?? DateTime(2000);
    final DateTime maxDate = widget.lastDate ?? now;

    // Ensure selectedDate is within the valid range
    if (selectedDate != null &&
        (selectedDate!.isBefore(minDate) || selectedDate!.isAfter(maxDate))) {
      // Reset selectedDate if it's out of range
      selectedDate = null;
      widget.controller.text = ''; // Clear the text field
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          selectedDate ?? maxDate, // Default to maxDate if selectedDate is null
      firstDate: minDate,
      lastDate: maxDate,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.controller.text = DateFormat('EEEE, d MMMM yyyy').format(picked);
      });
      if (widget.onChanged != null) {
        widget.onChanged!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      readOnly: true,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        fillColor: Colors.white,
        filled: true,
        labelStyle: TextStyle(color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ),
      onTap: () => _selectDate(context),
      onChanged: (value) {
        widget.onChanged;
      },
      textInputAction: TextInputAction.next,
      focusNode: widget.focusNode,
      onFieldSubmitted: (_) => widget.onFieldSubmitted(),
      validator: (value) {
        if (widget.isRequired) {
          if (value == null || value.isEmpty) {
            setState(() {
              widget.fieldHasError = true;
            });
            return widget.errorMsg;
          } else {
            setState(() {
              widget.fieldHasError = false;
            });
          }
        }
        return null;
      },
    );
  }

  DateTime? getSelectedDate() {
    return selectedDate;
  }
}
