import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

import '../../config/app_config.dart';
import '../../domain/entities/user.dart';
import '../../utils/exceptions/app_exceptions.dart';
import '../datasources/local/database/app_database.dart';
import '../models/user_model.dart';

/// Handles user authentication using the sembast local database.
class AuthRepository {
  AuthRepository({AppDatabase? database}) : _database = database;

  final AppDatabase? _database;
  final _uuid = const Uuid();

  User? _currentUser;

  User? get currentUser => _currentUser;

  StoreRef<String, Map<String, Object?>> get _store =>
      _database!.usersStore;

  Database get _db {
    if (_database == null) throw AppException('Database not available');
    return _database!.db;
  }

  // ---------------------------------------------------------------------------
  // Registration
  // ---------------------------------------------------------------------------

  Future<User> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? employeeId,
    String? airline,
    String? baseAirport,
  }) async {
    // Check for duplicate email
    final existing = await _store.findFirst(
      _db,
      finder: Finder(
          filter: Filter.equals('email', email.toLowerCase())),
    );
    if (existing != null) {
      throw AppException('An account with this email already exists.');
    }

    final now = DateTime.now();
    final userId = _uuid.v4();
    final passwordHash = _hashPassword(password);

    final user = User(
      id: userId,
      email: email.toLowerCase(),
      name: name,
      role: role,
      employeeId: employeeId,
      airline: airline,
      baseAirport: baseAirport,
      createdAt: now,
      updatedAt: now,
    );

    final model = UserModel.fromEntity(user, passwordHash: passwordHash);
    await _store.record(userId).put(_db, model.toMap());

    await AppConfig.setLoggedIn(value: true);
    await AppConfig.setCurrentUserId(userId);
    _currentUser = user;
    return user;
  }

  // ---------------------------------------------------------------------------
  // Login
  // ---------------------------------------------------------------------------

  Future<User> login({
    required String email,
    required String password,
  }) async {
    final record = await _store.findFirst(
      _db,
      finder: Finder(
          filter: Filter.equals('email', email.toLowerCase())),
    );

    if (record == null) {
      throw AppException('No account found with this email address.');
    }

    final model = UserModel.fromMap(record.value);
    if (model.passwordHash != _hashPassword(password)) {
      throw AppException('Incorrect password. Please try again.');
    }

    final user = model.toEntity();
    await AppConfig.setLoggedIn(value: true);
    await AppConfig.setCurrentUserId(user.id);
    _currentUser = user;
    return user;
  }

  // ---------------------------------------------------------------------------
  // Session restore
  // ---------------------------------------------------------------------------

  Future<User?> loadCurrentUser() async {
    final userId = AppConfig.currentUserId;
    if (userId == null) return null;

    final record = await _store.record(userId).get(_db);
    if (record == null) return null;

    final user = UserModel.fromMap(record).toEntity();
    _currentUser = user;
    return user;
  }

  Future<void> logout() async {
    _currentUser = null;
    await AppConfig.clearSession();
  }

  // ---------------------------------------------------------------------------
  // Profile update
  // ---------------------------------------------------------------------------

  Future<User> updateProfile(User user) async {
    final existing = await _store.record(user.id).get(_db);
    if (existing == null) throw AppException('User not found.');

    final passwordHash = UserModel.fromMap(existing).passwordHash;
    final updated = user.copyWith(updatedAt: DateTime.now());
    final model = UserModel.fromEntity(updated, passwordHash: passwordHash);

    await _store.record(updated.id).put(_db, model.toMap());
    _currentUser = updated;
    return updated;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}
