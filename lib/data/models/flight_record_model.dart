import '../../domain/entities/flight_record.dart';

/// SQLite/JSON data model for FlightRecord.
class FlightRecordModel {
  const FlightRecordModel({
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
    this.isOffDuty = 0,
    this.landings = 0,
    this.nightTimeMinutes = 0,
    this.instrumentTimeMinutes = 0,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String date;
  final String flightNumber;
  final String departureAirport;
  final String arrivalAirport;
  final String aircraftType;
  final String aircraftRegistration;
  final int blockTimeMinutes;
  final int dutyTimeMinutes;
  final String role;
  final String? remarks;
  final int isOffDuty;
  final int landings;
  final int nightTimeMinutes;
  final int instrumentTimeMinutes;
  final String? createdAt;
  final String? updatedAt;

  factory FlightRecordModel.fromMap(Map<String, dynamic> map) {
    return FlightRecordModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      date: map['date'] as String,
      flightNumber: map['flight_number'] as String,
      departureAirport: map['departure_airport'] as String,
      arrivalAirport: map['arrival_airport'] as String,
      aircraftType: map['aircraft_type'] as String,
      aircraftRegistration: map['aircraft_registration'] as String,
      blockTimeMinutes: map['block_time_minutes'] as int,
      dutyTimeMinutes: map['duty_time_minutes'] as int,
      role: map['role'] as String,
      remarks: map['remarks'] as String?,
      isOffDuty: (map['is_off_duty'] as int?) ?? 0,
      landings: (map['landings'] as int?) ?? 0,
      nightTimeMinutes: (map['night_time_minutes'] as int?) ?? 0,
      instrumentTimeMinutes:
          (map['instrument_time_minutes'] as int?) ?? 0,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'date': date,
      'flight_number': flightNumber,
      'departure_airport': departureAirport,
      'arrival_airport': arrivalAirport,
      'aircraft_type': aircraftType,
      'aircraft_registration': aircraftRegistration,
      'block_time_minutes': blockTimeMinutes,
      'duty_time_minutes': dutyTimeMinutes,
      'role': role,
      'remarks': remarks,
      'is_off_duty': isOffDuty,
      'landings': landings,
      'night_time_minutes': nightTimeMinutes,
      'instrument_time_minutes': instrumentTimeMinutes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  FlightRecord toEntity() {
    return FlightRecord(
      id: id,
      userId: userId,
      date: DateTime.parse(date),
      flightNumber: flightNumber,
      departureAirport: departureAirport,
      arrivalAirport: arrivalAirport,
      aircraftType: aircraftType,
      aircraftRegistration: aircraftRegistration,
      blockTimeMinutes: blockTimeMinutes,
      dutyTimeMinutes: dutyTimeMinutes,
      role: role,
      remarks: remarks,
      isOffDuty: isOffDuty == 1,
      landings: landings,
      nightTimeMinutes: nightTimeMinutes,
      instrumentTimeMinutes: instrumentTimeMinutes,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  factory FlightRecordModel.fromEntity(FlightRecord record) {
    return FlightRecordModel(
      id: record.id,
      userId: record.userId,
      date: record.date.toIso8601String().substring(0, 10),
      flightNumber: record.flightNumber,
      departureAirport: record.departureAirport,
      arrivalAirport: record.arrivalAirport,
      aircraftType: record.aircraftType,
      aircraftRegistration: record.aircraftRegistration,
      blockTimeMinutes: record.blockTimeMinutes,
      dutyTimeMinutes: record.dutyTimeMinutes,
      role: record.role,
      remarks: record.remarks,
      isOffDuty: record.isOffDuty ? 1 : 0,
      landings: record.landings,
      nightTimeMinutes: record.nightTimeMinutes,
      instrumentTimeMinutes: record.instrumentTimeMinutes,
      createdAt: record.createdAt?.toIso8601String(),
      updatedAt: record.updatedAt?.toIso8601String(),
    );
  }
}
