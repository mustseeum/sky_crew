import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../data/repositories/fatigue_repository.dart';
import '../../domain/entities/fatigue_entry.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/exceptions/app_exceptions.dart';
import '../controllers/auth_controller.dart';

/// Manages fatigue & wellness tracking.
class FatigueController extends GetxController {
  FatigueController({
    required FatigueRepository repository,
  }) : _repository = repository;

  final FatigueRepository _repository;
  final _uuid = const Uuid();

  final RxList<FatigueEntry> entries = <FatigueEntry>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Form fields
  final RxString formDate = ''.obs;
  final RxInt formFatigueScore = 5.obs;
  final RxDouble formSleepHours = 7.0.obs;
  final RxString formTimezone = AppConstants.commonTimezones.first.obs;
  final RxInt formWellnessScore = 7.obs;
  final RxInt formStressLevel = 3.obs;
  final RxString formNotes = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadEntries();
  }

  String get _userId {
    final auth = Get.find<AuthController>();
    return auth.currentUser.value?.id ?? '';
  }

  double get averageFatigue {
    if (entries.isEmpty) return 0;
    return entries.map((e) => e.fatigueScore).reduce((a, b) => a + b) /
        entries.length;
  }

  double get averageSleep {
    if (entries.isEmpty) return 0;
    return entries.map((e) => e.sleepHours).reduce((a, b) => a + b) /
        entries.length;
  }

  int get highFatigueCount =>
      entries.where((e) => e.isHighFatigue).length;

  Future<void> loadEntries({DateTime? from, DateTime? to}) async {
    if (_userId.isEmpty) return;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final data = await _repository.getFatigueEntries(
        _userId,
        from: from,
        to: to,
      );
      entries.assignAll(data);
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addEntry() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final entry = FatigueEntry(
        id: _uuid.v4(),
        userId: _userId,
        date: formDate.value.isNotEmpty
            ? DateTime.parse(formDate.value)
            : DateTime.now(),
        fatigueScore: formFatigueScore.value,
        sleepHours: formSleepHours.value,
        timezone: formTimezone.value,
        wellnessScore: formWellnessScore.value,
        stressLevel: formStressLevel.value,
        notes: formNotes.value.trim().isNotEmpty
            ? formNotes.value.trim()
            : null,
        createdAt: DateTime.now(),
      );

      await _repository.addFatigueEntry(entry);
      entries.insert(0, entry);
      _clearForm();
      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteEntry(String id) async {
    try {
      await _repository.deleteFatigueEntry(id);
      entries.removeWhere((e) => e.id == id);
      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    }
  }

  void _clearForm() {
    formDate.value = '';
    formFatigueScore.value = 5;
    formSleepHours.value = 7.0;
    formTimezone.value = AppConstants.commonTimezones.first;
    formWellnessScore.value = 7;
    formStressLevel.value = 3;
    formNotes.value = '';
  }
}
