import 'package:sembast/sembast.dart';

import 'db_factory.dart';

/// Manages the sembast database for offline-first data persistence.
/// Works on **all platforms** (iOS, Android, macOS, Windows, Linux, Web).
///
/// On native platforms the data is stored in a file in the app documents
/// directory. On Flutter Web it is persisted in the browser's IndexedDB.
class AppDatabase {
  static const String _databaseName = 'sky_crew.db';
  static const int _databaseVersion = 1;

  Database? _database;

  // ---------------------------------------------------------------------------
  // Stores (equivalent to SQL tables)
  // ---------------------------------------------------------------------------

  final StoreRef<String, Map<String, Object?>> usersStore =
      stringMapStoreFactory.store('users');

  final StoreRef<String, Map<String, Object?>> flightRecordsStore =
      stringMapStoreFactory.store('flight_records');

  final StoreRef<String, Map<String, Object?>> licensesStore =
      stringMapStoreFactory.store('licenses');

  final StoreRef<String, Map<String, Object?>> fatigueEntriesStore =
      stringMapStoreFactory.store('fatigue_entries');

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  Future<void> initialize() async {
    final path = await getDatabasePath(_databaseName);
    _database = await localDatabaseFactory.openDatabase(
      path,
      version: _databaseVersion,
    );
  }

  Database get db {
    if (_database == null) {
      throw StateError('Database not initialized. Call initialize() first.');
    }
    return _database!;
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
