import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/user.dart';
import '../datasources/local/database/app_database.dart';
import '../models/user_model.dart';
import '../../config/app_config.dart';
import '../../utils/exceptions/app_exceptions.dart';

/// Handles user authentication using local SQLite storage.
class AuthRepository {
  AuthRepository({AppDatabase? database}) : _database = database;

  final AppDatabase? _database;
  final _uuid = const Uuid();

  User? _currentUser;

  User? get currentUser => _currentUser;

  /// Registers a new user with hashed password.
  Future<User> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? employeeId,
    String? airline,
    String? baseAirport,
  }) async {
    final db = _database?.db;
    if (db == null) throw AppException('Database not available');

    // Check for existing email
    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
      limit: 1,
    );
    if (existing.isNotEmpty) {
      throw AppException('An account with this email already exists.');
    }

    final now = DateTime.now();
    final userId = _generateId();
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
    await db.insert('users', model.toMap());

    await AppConfig.setLoggedIn(value: true);
    await AppConfig.setCurrentUserId(userId);
    _currentUser = user;

    return user;
  }

  /// Authenticates a user with email and password.
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final db = _database?.db;
    if (db == null) throw AppException('Database not available');

    final results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
      limit: 1,
    );

    if (results.isEmpty) {
      throw AppException('No account found with this email address.');
    }

    final model = UserModel.fromMap(results.first);
    final expectedHash = _hashPassword(password);

    if (model.passwordHash != expectedHash) {
      throw AppException('Incorrect password. Please try again.');
    }

    final user = model.toEntity();
    await AppConfig.setLoggedIn(value: true);
    await AppConfig.setCurrentUserId(user.id);
    _currentUser = user;

    return user;
  }

  /// Loads the current user from the database by saved user ID.
  Future<User?> loadCurrentUser() async {
    final userId = AppConfig.currentUserId;
    if (userId == null) return null;

    final db = _database?.db;
    if (db == null) return null;

    final results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (results.isEmpty) return null;

    final user = UserModel.fromMap(results.first).toEntity();
    _currentUser = user;
    return user;
  }

  /// Signs the current user out.
  Future<void> logout() async {
    _currentUser = null;
    await AppConfig.clearSession();
  }

  /// Updates the current user's profile.
  Future<User> updateProfile(User user) async {
    final db = _database?.db;
    if (db == null) throw AppException('Database not available');

    final updated = user.copyWith(updatedAt: DateTime.now());
    final existing = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [user.id],
      limit: 1,
    );
    if (existing.isEmpty) throw AppException('User not found.');

    final passwordHash =
        UserModel.fromMap(existing.first).passwordHash;
    final model = UserModel.fromEntity(updated, passwordHash: passwordHash);

    await db.update(
      'users',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );

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

  String _generateId() => _uuid.v4();
}
