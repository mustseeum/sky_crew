import 'package:get/get.dart';

import '../../data/repositories/fatigue_repository.dart';
import '../controllers/fatigue_controller.dart';

/// Provides dependencies for the fatigue tracking screen.
class FatigueBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FatigueController>(
      () => FatigueController(
        repository: Get.find<FatigueRepository>(),
      ),
      fenix: true,
    );
  }
}
