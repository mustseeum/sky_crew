/// Represents a single flight/duty record in the logbook.
class FlightRecord {
  const FlightRecord({
    required this.id,
    required this.userId,
    required this.date,
    required this.flightNumber,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.aircraftType,
    required this.aircraftRegistration,
    required this.blockTimeMinutes,
    required this.dutyTimeMinutes,
    required this.role,
    this.remarks,
    this.isOffDuty = false,
    this.landings = 0,
    this.nightTimeMinutes = 0,
    this.instrumentTimeMinutes = 0,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final DateTime date;
  final String flightNumber;
  final String departureAirport;
  final String arrivalAirport;
  final String aircraftType;
  final String aircraftRegistration;

  /// Block time in minutes (from off-blocks to on-blocks).
  final int blockTimeMinutes;

  /// Total duty time in minutes.
  final int dutyTimeMinutes;

  /// Role of the crew member on this flight.
  final String role;

  final String? remarks;
  final bool isOffDuty;
  final int landings;
  final int nightTimeMinutes;
  final int instrumentTimeMinutes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  double get blockTimeHours => blockTimeMinutes / 60.0;
  double get dutyTimeHours => dutyTimeMinutes / 60.0;
  double get nightTimeHours => nightTimeMinutes / 60.0;
  double get instrumentTimeHours => instrumentTimeMinutes / 60.0;

  FlightRecord copyWith({
    String? id,
    String? userId,
    DateTime? date,
    String? flightNumber,
    String? departureAirport,
    String? arrivalAirport,
    String? aircraftType,
    String? aircraftRegistration,
    int? blockTimeMinutes,
    int? dutyTimeMinutes,
    String? role,
    String? remarks,
    bool? isOffDuty,
    int? landings,
    int? nightTimeMinutes,
    int? instrumentTimeMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FlightRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      flightNumber: flightNumber ?? this.flightNumber,
      departureAirport: departureAirport ?? this.departureAirport,
      arrivalAirport: arrivalAirport ?? this.arrivalAirport,
      aircraftType: aircraftType ?? this.aircraftType,
      aircraftRegistration:
          aircraftRegistration ?? this.aircraftRegistration,
      blockTimeMinutes: blockTimeMinutes ?? this.blockTimeMinutes,
      dutyTimeMinutes: dutyTimeMinutes ?? this.dutyTimeMinutes,
      role: role ?? this.role,
      remarks: remarks ?? this.remarks,
      isOffDuty: isOffDuty ?? this.isOffDuty,
      landings: landings ?? this.landings,
      nightTimeMinutes: nightTimeMinutes ?? this.nightTimeMinutes,
      instrumentTimeMinutes:
          instrumentTimeMinutes ?? this.instrumentTimeMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlightRecord &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
