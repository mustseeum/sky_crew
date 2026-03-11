import 'package:sembast/sembast.dart';

import '../../domain/entities/flight_record.dart';
import '../../utils/exceptions/app_exceptions.dart';
import '../datasources/local/database/app_database.dart';
import '../models/flight_record_model.dart';

/// Manages CRUD operations for flight/duty records.
class LogbookRepository {
  const LogbookRepository({required AppDatabase database})
      : _database = database;

  final AppDatabase _database;

  StoreRef<String, Map<String, Object?>> get _store =>
      _database.flightRecordsStore;

  Database get _db => _database.db;

  Future<List<FlightRecord>> getFlightRecords(String userId) async {
    final records = await _store.find(
      _db,
      finder: Finder(
        filter: Filter.equals('user_id', userId),
        sortOrders: [SortOrder('date', false)],
      ),
    );
    return records
        .map((r) => FlightRecordModel.fromMap(r.value).toEntity())
        .toList();
  }

  Future<FlightRecord?> getFlightRecord(String id) async {
    final record = await _store.record(id).get(_db);
    if (record == null) return null;
    return FlightRecordModel.fromMap(record).toEntity();
  }

  Future<FlightRecord> addFlightRecord(FlightRecord record) async {
    final model = FlightRecordModel.fromEntity(record);
    await _store.record(record.id).put(_db, model.toMap());
    return record;
  }

  Future<FlightRecord> updateFlightRecord(FlightRecord record) async {
    final existing = await _store.record(record.id).get(_db);
    if (existing == null) throw AppException('Flight record not found.');
    final updated = record.copyWith(updatedAt: DateTime.now());
    final model = FlightRecordModel.fromEntity(updated);
    await _store.record(updated.id).put(_db, model.toMap());
    return updated;
  }

  Future<void> deleteFlightRecord(String id) async {
    await _store.record(id).delete(_db);
  }

  /// Returns records within a date range for a user.
  Future<List<FlightRecord>> getFlightRecordsByDateRange(
    String userId,
    DateTime from,
    DateTime to,
  ) async {
    final fromStr = from.toIso8601String().substring(0, 10);
    final toStr = to.toIso8601String().substring(0, 10);

    final records = await _store.find(
      _db,
      finder: Finder(
        filter: Filter.and([
          Filter.equals('user_id', userId),
          Filter.greaterThanOrEquals('date', fromStr),
          Filter.lessThanOrEquals('date', toStr),
        ]),
        sortOrders: [SortOrder('date', false)],
      ),
    );
    return records
        .map((r) => FlightRecordModel.fromMap(r.value).toEntity())
        .toList();
  }
}
