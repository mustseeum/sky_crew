import 'package:get/get.dart';

import '../../data/repositories/fatigue_repository.dart';
import '../../data/repositories/license_repository.dart';
import '../../data/repositories/logbook_repository.dart';
import '../controllers/fatigue_controller.dart';
import '../controllers/license_controller.dart';
import '../controllers/logbook_controller.dart';

/// Provides dependencies for the home screen (all tabs).
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogbookController>(
      () => LogbookController(repository: Get.find<LogbookRepository>()),
      fenix: true,
    );
    Get.lazyPut<LicenseController>(
      () => LicenseController(repository: Get.find<LicenseRepository>()),
      fenix: true,
    );
    Get.lazyPut<FatigueController>(
      () => FatigueController(
        repository: Get.find<FatigueRepository>(),
      ),
      fenix: true,
    );
  }
}
