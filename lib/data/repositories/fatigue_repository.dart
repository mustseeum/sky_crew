import '../../domain/entities/fatigue_entry.dart';
import '../datasources/local/database/app_database.dart';
import '../models/fatigue_model.dart';
import '../../utils/exceptions/app_exceptions.dart';

/// Manages CRUD operations for fatigue/wellness entries.
class FatigueRepository {
  const FatigueRepository({required AppDatabase database})
      : _database = database;

  final AppDatabase _database;

  Future<List<FatigueEntry>> getFatigueEntries(
    String userId, {
    DateTime? from,
    DateTime? to,
  }) async {
    String where = 'user_id = ?';
    List<dynamic> whereArgs = [userId];

    if (from != null) {
      where += ' AND date >= ?';
      whereArgs.add(from.toIso8601String().substring(0, 10));
    }
    if (to != null) {
      where += ' AND date <= ?';
      whereArgs.add(to.toIso8601String().substring(0, 10));
    }

    final maps = await _database.db.query(
      'fatigue_entries',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'date DESC',
    );
    return maps.map((m) => FatigueModel.fromMap(m).toEntity()).toList();
  }

  Future<FatigueEntry> addFatigueEntry(FatigueEntry entry) async {
    final model = FatigueModel.fromEntity(entry);
    await _database.db.insert('fatigue_entries', model.toMap());
    return entry;
  }

  Future<FatigueEntry> updateFatigueEntry(FatigueEntry entry) async {
    final model = FatigueModel.fromEntity(entry);
    final count = await _database.db.update(
      'fatigue_entries',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
    if (count == 0) throw AppException('Fatigue entry not found.');
    return entry;
  }

  Future<void> deleteFatigueEntry(String id) async {
    await _database.db.delete(
      'fatigue_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
