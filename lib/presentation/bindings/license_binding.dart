import 'package:get/get.dart';

import '../../data/repositories/license_repository.dart';
import '../controllers/license_controller.dart';

/// Provides dependencies for the licenses screen.
class LicenseBinding extends Bindings {
  @override
  void dependencies() {
    // fenix: true keeps the controller alive when the standalone route is
    // popped so that the home shell's IndexedStack still finds it.
    Get.lazyPut<LicenseController>(
      () => LicenseController(repository: Get.find<LicenseRepository>()),
      fenix: true,
    );
  }
}
