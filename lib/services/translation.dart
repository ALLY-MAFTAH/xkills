import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../lang/en_us.dart';
import '../lang/sw_tz.dart';

class TranslationService extends Translations {
  final storage = GetStorage();

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'sw_TZ': swTZ,
      };

  Locale getLocale() {
    String? langCode = storage.read("locale");
    return Locale(langCode ?? 'en'); 
  }
}
