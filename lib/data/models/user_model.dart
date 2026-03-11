import '../../domain/entities/user.dart';

/// SQLite/JSON data model for User.
class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.passwordHash,
    this.employeeId,
    this.airline,
    this.baseAirport,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String email;
  final String name;
  final String role;
  final String passwordHash;
  final String? employeeId;
  final String? airline;
  final String? baseAirport;
  final String? createdAt;
  final String? updatedAt;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      role: map['role'] as String,
      passwordHash: map['password_hash'] as String,
      employeeId: map['employee_id'] as String?,
      airline: map['airline'] as String?,
      baseAirport: map['base_airport'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'password_hash': passwordHash,
      'employee_id': employeeId,
      'airline': airline,
      'base_airport': baseAirport,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      role: UserRole.fromString(role),
      employeeId: employeeId,
      airline: airline,
      baseAirport: baseAirport,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  factory UserModel.fromEntity(User user, {required String passwordHash}) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role.value,
      passwordHash: passwordHash,
      employeeId: user.employeeId,
      airline: user.airline,
      baseAirport: user.baseAirport,
      createdAt: user.createdAt?.toIso8601String(),
      updatedAt: user.updatedAt?.toIso8601String(),
    );
  }
}
