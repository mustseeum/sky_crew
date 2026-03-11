import 'package:sembast/sembast.dart';

import '../../domain/entities/license.dart';
import '../../utils/exceptions/app_exceptions.dart';
import '../datasources/local/database/app_database.dart';
import '../models/license_model.dart';

/// Manages CRUD operations for licenses and certifications.
class LicenseRepository {
  const LicenseRepository({required AppDatabase database})
      : _database = database;

  final AppDatabase _database;

  StoreRef<String, Map<String, Object?>> get _store =>
      _database.licensesStore;

  Database get _db => _database.db;

  Future<List<License>> getLicenses(String userId) async {
    final records = await _store.find(
      _db,
      finder: Finder(
        filter: Filter.equals('user_id', userId),
        sortOrders: [SortOrder('expiry_date')],
      ),
    );
    return records
        .map((r) => LicenseModel.fromMap(r.value).toEntity())
        .toList();
  }

  Future<License?> getLicense(String id) async {
    final record = await _store.record(id).get(_db);
    if (record == null) return null;
    return LicenseModel.fromMap(record).toEntity();
  }

  Future<License> addLicense(License license) async {
    final model = LicenseModel.fromEntity(license);
    await _store.record(license.id).put(_db, model.toMap());
    return license;
  }

  Future<License> updateLicense(License license) async {
    final existing = await _store.record(license.id).get(_db);
    if (existing == null) throw AppException('License not found.');
    final updated = license.copyWith(updatedAt: DateTime.now());
    final model = LicenseModel.fromEntity(updated);
    await _store.record(updated.id).put(_db, model.toMap());
    return updated;
  }

  Future<void> deleteLicense(String id) async {
    await _store.record(id).delete(_db);
  }
}
