import 'package:get/get.dart';

import '../../data/repositories/license_repository.dart';
import '../controllers/license_controller.dart';

/// Provides dependencies for the licenses screen.
class LicenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LicenseController>(
      () => LicenseController(repository: Get.find<LicenseRepository>()),
    );
  }
}
