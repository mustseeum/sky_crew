import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../../app/routes/app_routes.dart';
import '../../utils/exceptions/app_exceptions.dart';
import '../../utils/helpers/validation_helper.dart';

/// Manages authentication state and user session.
class AuthController extends GetxController {
  AuthController({required AuthRepository repository})
      : _repository = repository;

  final AuthRepository _repository;

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Form fields (login)
  final RxString loginEmail = ''.obs;
  final RxString loginPassword = ''.obs;

  // Form fields (register)
  final RxString registerEmail = ''.obs;
  final RxString registerPassword = ''.obs;
  final RxString registerConfirmPassword = ''.obs;
  final RxString registerName = ''.obs;
  final Rx<UserRole> registerRole = UserRole.pilot.obs;
  final RxString registerEmployeeId = ''.obs;
  final RxString registerAirline = ''.obs;
  final RxString registerBaseAirport = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _tryAutoLogin();
  }

  Future<void> _tryAutoLogin() async {
    try {
      final user = await _repository.loadCurrentUser();
      if (user != null) {
        currentUser.value = user;
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (_) {
      // No saved session, stay on login
    }
  }

  Future<void> login() async {
    errorMessage.value = '';
    final emailError = ValidationHelper.validateEmail(loginEmail.value);
    if (emailError != null) {
      errorMessage.value = emailError;
      return;
    }
    final passwordError =
        ValidationHelper.validatePassword(loginPassword.value);
    if (passwordError != null) {
      errorMessage.value = passwordError;
      return;
    }

    isLoading.value = true;
    try {
      final user = await _repository.login(
        email: loginEmail.value,
        password: loginPassword.value,
      );
      currentUser.value = user;
      Get.offAllNamed(AppRoutes.home);
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'An unexpected error occurred. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    errorMessage.value = '';
    final nameError = ValidationHelper.validateName(registerName.value);
    if (nameError != null) {
      errorMessage.value = nameError;
      return;
    }
    final emailError =
        ValidationHelper.validateEmail(registerEmail.value);
    if (emailError != null) {
      errorMessage.value = emailError;
      return;
    }
    final passwordError =
        ValidationHelper.validatePassword(registerPassword.value);
    if (passwordError != null) {
      errorMessage.value = passwordError;
      return;
    }
    if (registerPassword.value != registerConfirmPassword.value) {
      errorMessage.value = 'Passwords do not match.';
      return;
    }

    isLoading.value = true;
    try {
      final user = await _repository.register(
        email: registerEmail.value,
        password: registerPassword.value,
        name: registerName.value,
        role: registerRole.value,
        employeeId: registerEmployeeId.value.isNotEmpty
            ? registerEmployeeId.value
            : null,
        airline: registerAirline.value.isNotEmpty
            ? registerAirline.value
            : null,
        baseAirport: registerBaseAirport.value.isNotEmpty
            ? registerBaseAirport.value
            : null,
      );
      currentUser.value = user;
      Get.offAllNamed(AppRoutes.home);
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'An unexpected error occurred. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
