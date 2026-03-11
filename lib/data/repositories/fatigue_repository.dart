import 'package:sembast/sembast.dart';

import '../../domain/entities/fatigue_entry.dart';
import '../../utils/exceptions/app_exceptions.dart';
import '../datasources/local/database/app_database.dart';
import '../models/fatigue_model.dart';

/// Manages CRUD operations for fatigue/wellness entries.
class FatigueRepository {
  const FatigueRepository({required AppDatabase database})
      : _database = database;

  final AppDatabase _database;

  StoreRef<String, Map<String, Object?>> get _store =>
      _database.fatigueEntriesStore;

  Database get _db => _database.db;

  Future<List<FatigueEntry>> getFatigueEntries(
    String userId, {
    DateTime? from,
    DateTime? to,
  }) async {
    final filters = <Filter>[Filter.equals('user_id', userId)];

    if (from != null) {
      filters.add(Filter.greaterThanOrEquals(
        'date',
        from.toIso8601String().substring(0, 10),
      ));
    }
    if (to != null) {
      filters.add(Filter.lessThanOrEquals(
        'date',
        to.toIso8601String().substring(0, 10),
      ));
    }

    final records = await _store.find(
      _db,
      finder: Finder(
        filter: Filter.and(filters),
        sortOrders: [SortOrder('date', false)],
      ),
    );
    return records
        .map((r) => FatigueModel.fromMap(r.value).toEntity())
        .toList();
  }

  Future<FatigueEntry> addFatigueEntry(FatigueEntry entry) async {
    final model = FatigueModel.fromEntity(entry);
    await _store.record(entry.id).put(_db, model.toMap());
    return entry;
  }

  Future<FatigueEntry> updateFatigueEntry(FatigueEntry entry) async {
    final existing = await _store.record(entry.id).get(_db);
    if (existing == null) throw AppException('Fatigue entry not found.');
    final model = FatigueModel.fromEntity(entry);
    await _store.record(entry.id).put(_db, model.toMap());
    return entry;
  }

  Future<void> deleteFatigueEntry(String id) async {
    await _store.record(id).delete(_db);
  }
}
