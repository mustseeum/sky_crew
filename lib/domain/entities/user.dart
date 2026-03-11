/// Defines the role of a crew member.
enum UserRole {
  pilot,
  copilot,
  flightAttendant,
  supervisor;

  String get displayName {
    switch (this) {
      case UserRole.pilot:
        return 'Pilot';
      case UserRole.copilot:
        return 'Co-Pilot';
      case UserRole.flightAttendant:
        return 'Flight Attendant';
      case UserRole.supervisor:
        return 'Supervisor';
    }
  }

  String get value {
    switch (this) {
      case UserRole.pilot:
        return 'pilot';
      case UserRole.copilot:
        return 'copilot';
      case UserRole.flightAttendant:
        return 'flight_attendant';
      case UserRole.supervisor:
        return 'supervisor';
    }
  }

  static UserRole fromString(String value) {
    switch (value) {
      case 'pilot':
        return UserRole.pilot;
      case 'copilot':
        return UserRole.copilot;
      case 'flight_attendant':
        return UserRole.flightAttendant;
      case 'supervisor':
        return UserRole.supervisor;
      default:
        return UserRole.pilot;
    }
  }
}

/// Core user domain entity.
class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.employeeId,
    this.airline,
    this.baseAirport,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? employeeId;
  final String? airline;
  final String? baseAirport;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? employeeId,
    String? airline,
    String? baseAirport,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      employeeId: employeeId ?? this.employeeId,
      airline: airline ?? this.airline,
      baseAirport: baseAirport ?? this.baseAirport,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(id: $id, email: $email, role: ${role.value})';
}
