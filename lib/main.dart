// Entry point for the SkyCrew Flutter application.
// Supports: Android · iOS · macOS · Windows · Linux · **Flutter Web**
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'config/app_config.dart';
import 'data/datasources/local/database/app_database.dart';
import 'presentation/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences (works on all platforms including web)
  await AppConfig.initialize();

  // Initialize and register database before bindings/controllers are resolved.
  final database = AppDatabase();
  await database.initialize();
  Get.put<AppDatabase>(database, permanent: true);

  runApp(const SkyCrewApp());
}

class SkyCrewApp extends StatelessWidget {
  const SkyCrewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SkyCrew',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
