import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skillsbank/theme/app_colors.dart';
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
        fontFamily: 'Nunito Sans',
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          tertiary: AppColors.tertiaryColor,
        ),
        useMaterial3: true,
      ),

      home: const SplashScreen(),
    );
  }
}
