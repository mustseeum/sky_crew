import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Manages the SQLite database for offline-first data persistence.
class AppDatabase {
  static const String _databaseName = 'sky_crew.db';
  static const int _databaseVersion = 1;

  Database? _database;

  Future<void> initialize() async {
    _database = await _openDatabase();
  }

  Database get db {
    if (_database == null) {
      throw StateError('Database not initialized. Call initialize() first.');
    }
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_createUsersTable);
    await db.execute(_createFlightRecordsTable);
    await db.execute(_createLicensesTable);
    await db.execute(_createFatigueEntriesTable);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implement migration logic here when schema changes
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }

  // ---------------------------------------------------------------------------
  // Schema definitions
  // ---------------------------------------------------------------------------

  static const _createUsersTable = '''
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      email TEXT NOT NULL UNIQUE,
      name TEXT NOT NULL,
      role TEXT NOT NULL,
      password_hash TEXT NOT NULL,
      employee_id TEXT,
      airline TEXT,
      base_airport TEXT,
      created_at TEXT,
      updated_at TEXT
    )
  ''';

  static const _createFlightRecordsTable = '''
    CREATE TABLE IF NOT EXISTS flight_records (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      date TEXT NOT NULL,
      flight_number TEXT NOT NULL,
      departure_airport TEXT NOT NULL,
      arrival_airport TEXT NOT NULL,
      aircraft_type TEXT NOT NULL,
      aircraft_registration TEXT NOT NULL,
      block_time_minutes INTEGER NOT NULL DEFAULT 0,
      duty_time_minutes INTEGER NOT NULL DEFAULT 0,
      role TEXT NOT NULL,
      remarks TEXT,
      is_off_duty INTEGER NOT NULL DEFAULT 0,
      landings INTEGER NOT NULL DEFAULT 0,
      night_time_minutes INTEGER NOT NULL DEFAULT 0,
      instrument_time_minutes INTEGER NOT NULL DEFAULT 0,
      created_at TEXT,
      updated_at TEXT,
      FOREIGN KEY (user_id) REFERENCES users (id)
    )
  ''';

  static const _createLicensesTable = '''
    CREATE TABLE IF NOT EXISTS licenses (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      type TEXT NOT NULL,
      number TEXT NOT NULL,
      issuing_authority TEXT NOT NULL,
      issue_date TEXT NOT NULL,
      expiry_date TEXT NOT NULL,
      ratings TEXT,
      remarks TEXT,
      created_at TEXT,
      updated_at TEXT,
      FOREIGN KEY (user_id) REFERENCES users (id)
    )
  ''';

  static const _createFatigueEntriesTable = '''
    CREATE TABLE IF NOT EXISTS fatigue_entries (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      date TEXT NOT NULL,
      fatigue_score INTEGER NOT NULL,
      sleep_hours REAL NOT NULL,
      timezone TEXT NOT NULL,
      wellness_score INTEGER,
      stress_level INTEGER,
      notes TEXT,
      created_at TEXT,
      FOREIGN KEY (user_id) REFERENCES users (id)
    )
  ''';
}
