import '../../domain/entities/license.dart';
import '../datasources/local/database/app_database.dart';
import '../models/license_model.dart';
import '../../utils/exceptions/app_exceptions.dart';

/// Manages CRUD operations for licenses and certifications.
class LicenseRepository {
  const LicenseRepository({required AppDatabase database})
      : _database = database;

  final AppDatabase _database;

  Future<List<License>> getLicenses(String userId) async {
    final maps = await _database.db.query(
      'licenses',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'expiry_date ASC',
    );
    return maps.map((m) => LicenseModel.fromMap(m).toEntity()).toList();
  }

  Future<License?> getLicense(String id) async {
    final maps = await _database.db.query(
      'licenses',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return LicenseModel.fromMap(maps.first).toEntity();
  }

  Future<License> addLicense(License license) async {
    final model = LicenseModel.fromEntity(license);
    await _database.db.insert('licenses', model.toMap());
    return license;
  }

  Future<License> updateLicense(License license) async {
    final updated = license.copyWith(updatedAt: DateTime.now());
    final model = LicenseModel.fromEntity(updated);
    final count = await _database.db.update(
      'licenses',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [license.id],
    );
    if (count == 0) throw AppException('License not found.');
    return updated;
  }

  Future<void> deleteLicense(String id) async {
    await _database.db.delete(
      'licenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
