import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'form_fields/date_form_field.dart';

bool isEmailValid(String value) {
  String pattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-zA-Z]{2,4})$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(value);
}

bool isShortPhoneNumberValid(String value) {
  String pattern = r'^0\d{9}$'; // Starts with 0, followed by 9 digits
  return RegExp(pattern).hasMatch(value);
}

bool isLongPhoneNumberValid(String value) {
  String pattern = r'^\+255\d{9}$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(value);
}

bool isNidaValid(String value) {
  String pattern = r'^\d{20}$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(value);
}

String convertToInternationalFormat(String localNumber) {
  if (localNumber.startsWith('0') && localNumber.length == 10) {
    return '255${localNumber.substring(1)}';
  }
  return localNumber;
}

String convertToLocalFormat(String internationalNumber) {
  if (internationalNumber.startsWith('255') &&
      internationalNumber.length == 12) {
    return '0${internationalNumber.substring(3)}';
  }
  return internationalNumber;
}

String getFormattedSelectedDate(
  GlobalKey<DateFormFieldState> dateFormFieldKey,
) {
  DateTime? selectedDate = dateFormFieldKey.currentState?.getSelectedDate();

  if (selectedDate != null) {
    DateTime withTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      DateTime.now().hour,
      DateTime.now().minute,
      DateTime.now().second,
      DateTime.now().millisecond,
    );

    return withTime.toUtc().toIso8601String();
  }

  return "";
}

String getFormattedDateTime(DateTime selectedDate) {
  DateTime withTime = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    DateTime.now().hour,
    DateTime.now().minute,
    DateTime.now().second,
    DateTime.now().millisecond,
  );

  return withTime.toUtc().toIso8601String();
}

String getFormattedDate(DateTime date) {
  return DateFormat('EE, d MMM yyyy').format(date);
}

String getMoneyFormat(double amount) {
  final formatter = NumberFormat('#,##0', 'en_US');
  return 'Tsh ${formatter.format(amount)}';
}

String getMoneyFormatShort(double amount) {
  if (amount >= 10_000_000) {
    double shortAmount = amount / 1_000_000;
    String formatted =
        shortAmount % 1 == 0
            ? shortAmount.toStringAsFixed(0)
            : shortAmount.toStringAsFixed(1);
    return 'Tsh ${formatted}M';
  } else {
    final formatter = NumberFormat('#,##0', 'en_US');
    return 'Tsh ${formatter.format(amount)}';
  }
}

String calculateAge(DateTime birthDate) {
  DateTime today = DateTime.now();
  int age = today.year - birthDate.year;
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }

  return age.toString();
}

String getInitial(String fullName) {
  if (fullName.isEmpty) return '';

  // Trim whitespace and split the name
  final nameParts = fullName.trim().split(' ');

  // Return first character of first non-empty part, converted to uppercase
  return nameParts
      .firstWhere((part) => part.isNotEmpty, orElse: () => '')
      .characters
      .first
      .toUpperCase();
}
