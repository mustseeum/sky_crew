import 'package:get/get.dart';

import '../../data/repositories/logbook_repository.dart';
import '../controllers/logbook_controller.dart';

/// Provides dependencies for logbook screens.
class LogbookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogbookController>(
      () => LogbookController(repository: Get.find<LogbookRepository>()),
    );
  }
}
