import 'package:get/get.dart';

import '../../data/repositories/logbook_repository.dart';
import '../controllers/logbook_controller.dart';

/// Provides dependencies for logbook screens.
class LogbookBinding extends Bindings {
  @override
  void dependencies() {
    // fenix: true keeps the controller alive when the standalone route is
    // popped so that the home shell's IndexedStack still finds it.
    Get.lazyPut<LogbookController>(
      () => LogbookController(repository: Get.find<LogbookRepository>()),
      fenix: true,
    );
  }
}
