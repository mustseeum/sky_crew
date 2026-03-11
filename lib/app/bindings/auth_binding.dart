import 'package:get/get.dart';

import '../../presentation/controllers/auth_controller.dart';
import '../../data/repositories/auth_repository.dart';

/// Auth binding — AuthController is already registered globally in InitialBinding.
/// This binding is kept for explicit route association.
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(repository: Get.find<AuthRepository>()),
      fenix: true,
    );
  }
}
