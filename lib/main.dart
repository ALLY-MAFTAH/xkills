import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/date_symbol_data_local.dart';

import '/theme/app_colors.dart';
import 'services/translation.dart';
import 'views/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await GetStorage.init();

  await initializeDateFormatting('en', null);
  await initializeDateFormatting('sw', null);


  // 🔔 Notification permission (Android 13+)
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
// FlutterMemoryAllocations.instance.addListener(
//     (ObjectEvent event) => LeakTracking.dispatchObjectEvent(event.toMap()),
//   );
//   LeakTracking.start();
//   LeakTracking.phase = PhaseSettings(
//     leakDiagnosticConfig: LeakDiagnosticConfig(collectStackTraceOnStart: true),
//   );
//   LgrLogs.initAllLogs();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: TranslationService(),
        locale: TranslationService().getLocale(),
        fallbackLocale: const Locale('en', 'US'),
      home: const SplashScreen(),

      theme: ThemeData(
        useMaterial3: true,
        typography: Typography.material2021(),

        // 🎨 COLOR SCHEME
        colorScheme:  ColorScheme.light(
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          tertiary: AppColors.tertiaryColor,
        ),

        // 🌟 GLOBAL FONT (Inter Variable)
        fontFamily: 'Inter',

        // 🧠 TEXT STYLES
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
          ),
          displayMedium: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          labelLarge: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),

        // 🎯 ICONS
        iconTheme: const IconThemeData(color: Colors.white),

        // 🚀 ELEVATED BUTTON (GLOBAL RISE EFFECT)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) return 12;
              return 4;
            }),
            animationDuration: const Duration(milliseconds: 180),
            overlayColor: WidgetStateProperty.all(
              Colors.white.withOpacity(0.1),
            ),
          ),
        ),

        // ✨ TEXT BUTTON
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(
              Colors.white.withOpacity(0.08),
            ),
          ),
        ),

        // 🔲 OUTLINED BUTTON
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(
              Colors.white.withOpacity(0.08),
            ),
          ),
        ),
      ),
    );
  }
}
