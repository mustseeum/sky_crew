import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../data/repositories/logbook_repository.dart';
import '../../domain/entities/flight_record.dart';
import '../../utils/exceptions/app_exceptions.dart';
import '../../utils/helpers/calculation_engine.dart';
import '../../utils/helpers/export_helper.dart';
import '../controllers/auth_controller.dart';

/// Manages the logbook: CRUD + summaries + exports.
class LogbookController extends GetxController {
  LogbookController({required LogbookRepository repository})
      : _repository = repository;

  final LogbookRepository _repository;
  final _uuid = const Uuid();

  final RxList<FlightRecord> records = <FlightRecord>[].obs;
  final Rx<FlightRecord?> selectedRecord = Rx<FlightRecord?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isExporting = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<LogbookSummary?> summary = Rx<LogbookSummary?>(null);

  // Add/edit form fields
  final RxString formDate = ''.obs;
  final RxString formFlightNumber = ''.obs;
  final RxString formDepartureAirport = ''.obs;
  final RxString formArrivalAirport = ''.obs;
  final RxString formAircraftType = ''.obs;
  final RxString formAircraftRegistration = ''.obs;
  final RxInt formBlockTimeMinutes = 0.obs;
  final RxInt formDutyTimeMinutes = 0.obs;
  final RxString formRole = ''.obs;
  final RxString formRemarks = ''.obs;
  final RxInt formLandings = 0.obs;
  final RxInt formNightTimeMinutes = 0.obs;
  final RxBool formIsOffDuty = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecords();
  }

  String get _userId {
    final auth = Get.find<AuthController>();
    return auth.currentUser.value?.id ?? '';
  }

  Future<void> loadRecords() async {
    if (_userId.isEmpty) return;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final data = await _repository.getFlightRecords(_userId);
      records.assignAll(data);
      _updateSummary();
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addRecord() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final record = FlightRecord(
        id: _uuid.v4(),
        userId: _userId,
        date: DateTime.parse(formDate.value),
        flightNumber: formFlightNumber.value.trim(),
        departureAirport: formDepartureAirport.value.trim().toUpperCase(),
        arrivalAirport: formArrivalAirport.value.trim().toUpperCase(),
        aircraftType: formAircraftType.value.trim(),
        aircraftRegistration: formAircraftRegistration.value.trim().toUpperCase(),
        blockTimeMinutes: formBlockTimeMinutes.value,
        dutyTimeMinutes: formDutyTimeMinutes.value,
        role: formRole.value,
        remarks: formRemarks.value.trim().isNotEmpty
            ? formRemarks.value.trim()
            : null,
        landings: formLandings.value,
        nightTimeMinutes: formNightTimeMinutes.value,
        isOffDuty: formIsOffDuty.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _repository.addFlightRecord(record);
      records.insert(0, record);
      _updateSummary();
      _clearForm();
      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateRecord(String id) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final index = records.indexWhere((r) => r.id == id);
      if (index == -1) {
        errorMessage.value = 'Record not found.';
        return false;
      }

      final updated = records[index].copyWith(
        date: DateTime.parse(formDate.value),
        flightNumber: formFlightNumber.value.trim(),
        departureAirport: formDepartureAirport.value.trim().toUpperCase(),
        arrivalAirport: formArrivalAirport.value.trim().toUpperCase(),
        aircraftType: formAircraftType.value.trim(),
        aircraftRegistration: formAircraftRegistration.value.trim().toUpperCase(),
        blockTimeMinutes: formBlockTimeMinutes.value,
        dutyTimeMinutes: formDutyTimeMinutes.value,
        role: formRole.value,
        remarks: formRemarks.value.trim().isNotEmpty
            ? formRemarks.value.trim()
            : null,
        landings: formLandings.value,
        nightTimeMinutes: formNightTimeMinutes.value,
        isOffDuty: formIsOffDuty.value,
        updatedAt: DateTime.now(),
      );

      await _repository.updateFlightRecord(updated);
      records[index] = updated;
      _updateSummary();
      _clearForm();
      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteRecord(String id) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _repository.deleteFlightRecord(id);
      records.removeWhere((r) => r.id == id);
      _updateSummary();
      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void selectRecord(FlightRecord record) {
    selectedRecord.value = record;
    _populateFormFromRecord(record);
  }

  void clearSelectedRecord() {
    selectedRecord.value = null;
    _clearForm();
  }

  Future<String?> exportToCSV() async {
    isExporting.value = true;
    try {
      final auth = Get.find<AuthController>();
      final path = await ExportHelper.exportToCSV(
        records,
        filename: 'logbook_${auth.currentUser.value?.name ?? 'export'}.csv',
      );
      return path;
    } catch (e) {
      errorMessage.value = 'Export failed: ${e.toString()}';
      return null;
    } finally {
      isExporting.value = false;
    }
  }

  Future<String?> exportToPDF() async {
    isExporting.value = true;
    try {
      final auth = Get.find<AuthController>();
      final path = await ExportHelper.exportToPDF(
        records,
        crewName: auth.currentUser.value?.name ?? '',
      );
      return path;
    } catch (e) {
      errorMessage.value = 'Export failed: ${e.toString()}';
      return null;
    } finally {
      isExporting.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  void _updateSummary() {
    summary.value = CalculationEngine.generateSummary(records);
  }

  void _populateFormFromRecord(FlightRecord record) {
    formDate.value = record.date.toIso8601String().substring(0, 10);
    formFlightNumber.value = record.flightNumber;
    formDepartureAirport.value = record.departureAirport;
    formArrivalAirport.value = record.arrivalAirport;
    formAircraftType.value = record.aircraftType;
    formAircraftRegistration.value = record.aircraftRegistration;
    formBlockTimeMinutes.value = record.blockTimeMinutes;
    formDutyTimeMinutes.value = record.dutyTimeMinutes;
    formRole.value = record.role;
    formRemarks.value = record.remarks ?? '';
    formLandings.value = record.landings;
    formNightTimeMinutes.value = record.nightTimeMinutes;
    formIsOffDuty.value = record.isOffDuty;
  }

  void _clearForm() {
    formDate.value = '';
    formFlightNumber.value = '';
    formDepartureAirport.value = '';
    formArrivalAirport.value = '';
    formAircraftType.value = '';
    formAircraftRegistration.value = '';
    formBlockTimeMinutes.value = 0;
    formDutyTimeMinutes.value = 0;
    formRole.value = '';
    formRemarks.value = '';
    formLandings.value = 0;
    formNightTimeMinutes.value = 0;
    formIsOffDuty.value = false;
  }
}
