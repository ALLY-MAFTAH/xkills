import 'package:flutter/material.dart';
import '/enums/enums.dart';

class ServiceProvider {
  ServiceProviderName? name;
  String? logo;
  Color? backColor;
  Color? foreColor;

  ServiceProvider({
    required this.name,
    required this.logo,
    required this.backColor,
    required this.foreColor,
  });
}
