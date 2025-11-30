import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import '/theme/app_colors.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'constants/auth_user.dart';
import 'views/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  await initializeDateFormatting('en', null);
  await initializeDateFormatting('sw', null);
  await Auth().loadAuthUser();
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          tertiary: AppColors.tertiaryColor,
        ),

        // Default app text uses MYRIAD (body text)
        fontFamily: "Myriad",

        textTheme: TextTheme(
          // Headings use UNITEA
          displayLarge: const TextStyle(
            fontFamily: "Unitea",
            fontWeight: FontWeight.w900,
          ),
          displayMedium: const TextStyle(
            fontFamily: "Unitea",
            fontWeight: FontWeight.w800,
          ),
          headlineLarge: const TextStyle(
            fontFamily: "Unitea",
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: const TextStyle(
            fontFamily: "Unitea",
            fontWeight: FontWeight.w600,
          ),
          titleLarge: const TextStyle(
            fontFamily: "Unitea",
            fontWeight: FontWeight.w600,
          ),

          // Body text uses Myriad
          bodyLarge: const TextStyle(fontFamily: "Myriad", fontSize: 18),
          bodyMedium: const TextStyle(fontFamily: "Myriad", fontSize: 16),
          bodySmall: const TextStyle(fontFamily: "Myriad", fontSize: 14),

          labelLarge: const TextStyle(
            fontFamily: "Myriad",
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),

        iconTheme: const IconThemeData(color: Colors.white),
      ),

      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
