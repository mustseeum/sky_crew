import 'dart:async';

import 'package:get/get.dart';

import '../../data/datasources/local/database/app_database.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/fatigue_repository.dart';
import '../../data/repositories/license_repository.dart';
import '../../data/repositories/logbook_repository.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/navigation_controller.dart';
import '../../presentation/controllers/settings_controller.dart';

/// Registers global dependencies that persist for the app's lifetime.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Defensive fallback for cases where app hot-reload/restart state loses
    // the pre-registered database instance from main().
    if (!Get.isRegistered<AppDatabase>()) {
      final database = AppDatabase();
      Get.put<AppDatabase>(database, permanent: true);
      unawaited(database.initialize());
    }

    // Repositories
    Get.lazyPut<AuthRepository>(
      () => AuthRepository(database: Get.find<AppDatabase>()),
      fenix: true,
    );
    Get.lazyPut<LogbookRepository>(
      () => LogbookRepository(database: Get.find<AppDatabase>()),
      fenix: true,
    );
    Get.lazyPut<LicenseRepository>(
      () => LicenseRepository(database: Get.find<AppDatabase>()),
      fenix: true,
    );
    Get.lazyPut<FatigueRepository>(
      () => FatigueRepository(database: Get.find<AppDatabase>()),
      fenix: true,
    );

    // Auth controller is permanent – registered once for the app lifetime.
    Get.put<AuthController>(
      AuthController(repository: Get.find<AuthRepository>()),
      permanent: true,
    );

    // Settings controller is permanent (drives theme + locale for the app).
    if (!Get.isRegistered<SettingsController>()) {
      Get.put<SettingsController>(SettingsController(), permanent: true);
    }

    // Navigation controller
    Get.put(NavigationController(), permanent: true);
  }
}
