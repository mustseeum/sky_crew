import '../../domain/entities/flight_record.dart';
import '../datasources/local/database/app_database.dart';
import '../models/flight_record_model.dart';
import '../../utils/exceptions/app_exceptions.dart';

/// Manages CRUD operations for flight/duty records.
class LogbookRepository {
  const LogbookRepository({required AppDatabase database})
      : _database = database;

  final AppDatabase _database;

  Future<List<FlightRecord>> getFlightRecords(String userId) async {
    final maps = await _database.db.query(
      'flight_records',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return maps.map((m) => FlightRecordModel.fromMap(m).toEntity()).toList();
  }

  Future<FlightRecord?> getFlightRecord(String id) async {
    final maps = await _database.db.query(
      'flight_records',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return FlightRecordModel.fromMap(maps.first).toEntity();
  }

  Future<FlightRecord> addFlightRecord(FlightRecord record) async {
    final model = FlightRecordModel.fromEntity(record);
    await _database.db.insert('flight_records', model.toMap());
    return record;
  }

  Future<FlightRecord> updateFlightRecord(FlightRecord record) async {
    final updated = record.copyWith(updatedAt: DateTime.now());
    final model = FlightRecordModel.fromEntity(updated);
    final count = await _database.db.update(
      'flight_records',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
    if (count == 0) throw AppException('Flight record not found.');
    return updated;
  }

  Future<void> deleteFlightRecord(String id) async {
    await _database.db.delete(
      'flight_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Returns records within a date range for a user.
  Future<List<FlightRecord>> getFlightRecordsByDateRange(
    String userId,
    DateTime from,
    DateTime to,
  ) async {
    final maps = await _database.db.query(
      'flight_records',
      where: 'user_id = ? AND date >= ? AND date <= ?',
      whereArgs: [
        userId,
        from.toIso8601String().substring(0, 10),
        to.toIso8601String().substring(0, 10),
      ],
      orderBy: 'date DESC',
    );
    return maps.map((m) => FlightRecordModel.fromMap(m).toEntity()).toList();
  }
}
