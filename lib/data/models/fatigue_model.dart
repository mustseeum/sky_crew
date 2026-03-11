import '../../domain/entities/fatigue_entry.dart';

/// SQLite/JSON data model for FatigueEntry.
class FatigueModel {
  const FatigueModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.fatigueScore,
    required this.sleepHours,
    required this.timezone,
    this.wellnessScore,
    this.stressLevel,
    this.notes,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String date;
  final int fatigueScore;
  final double sleepHours;
  final String timezone;
  final int? wellnessScore;
  final int? stressLevel;
  final String? notes;
  final String? createdAt;

  factory FatigueModel.fromMap(Map<String, dynamic> map) {
    return FatigueModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      date: map['date'] as String,
      fatigueScore: map['fatigue_score'] as int,
      sleepHours: (map['sleep_hours'] as num).toDouble(),
      timezone: map['timezone'] as String,
      wellnessScore: map['wellness_score'] as int?,
      stressLevel: map['stress_level'] as int?,
      notes: map['notes'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'date': date,
      'fatigue_score': fatigueScore,
      'sleep_hours': sleepHours,
      'timezone': timezone,
      'wellness_score': wellnessScore,
      'stress_level': stressLevel,
      'notes': notes,
      'created_at': createdAt,
    };
  }

  FatigueEntry toEntity() {
    return FatigueEntry(
      id: id,
      userId: userId,
      date: DateTime.parse(date),
      fatigueScore: fatigueScore,
      sleepHours: sleepHours,
      timezone: timezone,
      wellnessScore: wellnessScore,
      stressLevel: stressLevel,
      notes: notes,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
    );
  }

  factory FatigueModel.fromEntity(FatigueEntry entry) {
    return FatigueModel(
      id: entry.id,
      userId: entry.userId,
      date: entry.date.toIso8601String().substring(0, 10),
      fatigueScore: entry.fatigueScore,
      sleepHours: entry.sleepHours,
      timezone: entry.timezone,
      wellnessScore: entry.wellnessScore,
      stressLevel: entry.stressLevel,
      notes: entry.notes,
      createdAt: entry.createdAt?.toIso8601String(),
    );
  }
}
