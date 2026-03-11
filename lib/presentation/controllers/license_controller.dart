import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../data/repositories/license_repository.dart';
import '../../domain/entities/license.dart';
import '../../utils/exceptions/app_exceptions.dart';
import '../controllers/auth_controller.dart';

/// Manages licenses and currency tracking.
class LicenseController extends GetxController {
  LicenseController({required LicenseRepository repository})
      : _repository = repository;

  final LicenseRepository _repository;
  final _uuid = const Uuid();

  final RxList<License> licenses = <License>[].obs;
  final Rx<License?> selectedLicense = Rx<License?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Form fields
  final RxString formType = ''.obs;
  final RxString formNumber = ''.obs;
  final RxString formIssuingAuthority = ''.obs;
  final RxString formIssueDate = ''.obs;
  final RxString formExpiryDate = ''.obs;
  final RxString formRemarks = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadLicenses();
  }

  String get _userId {
    final auth = Get.find<AuthController>();
    return auth.currentUser.value?.id ?? '';
  }

  List<License> get expiringLicenses =>
      licenses.where((l) => l.isExpiringSoon).toList();

  List<License> get expiredLicenses =>
      licenses.where((l) => l.isExpired).toList();

  List<License> get validLicenses =>
      licenses.where((l) => !l.isExpired).toList();

  Future<void> loadLicenses() async {
    if (_userId.isEmpty) return;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final data = await _repository.getLicenses(_userId);
      licenses.assignAll(data);
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addLicense() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final license = License(
        id: _uuid.v4(),
        userId: _userId,
        type: formType.value.trim(),
        number: formNumber.value.trim(),
        issuingAuthority: formIssuingAuthority.value.trim(),
        issueDate: DateTime.parse(formIssueDate.value),
        expiryDate: DateTime.parse(formExpiryDate.value),
        remarks: formRemarks.value.trim().isNotEmpty
            ? formRemarks.value.trim()
            : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _repository.addLicense(license);
      licenses.add(license);
      licenses.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
      _clearForm();
      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteLicense(String id) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _repository.deleteLicense(id);
      licenses.removeWhere((l) => l.id == id);
      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void selectLicense(License license) {
    selectedLicense.value = license;
    formType.value = license.type;
    formNumber.value = license.number;
    formIssuingAuthority.value = license.issuingAuthority;
    formIssueDate.value =
        license.issueDate.toIso8601String().substring(0, 10);
    formExpiryDate.value =
        license.expiryDate.toIso8601String().substring(0, 10);
    formRemarks.value = license.remarks ?? '';
  }

  void _clearForm() {
    formType.value = '';
    formNumber.value = '';
    formIssuingAuthority.value = '';
    formIssueDate.value = '';
    formExpiryDate.value = '';
    formRemarks.value = '';
  }
}
