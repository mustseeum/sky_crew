/// Represents a single fatigue/wellness self-assessment entry.
class FatigueEntry {
  const FatigueEntry({
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
  final DateTime date;

  /// Self-assessed fatigue score 1–10 (1 = fully rested, 10 = extremely fatigued).
  final int fatigueScore;

  /// Hours of sleep before duty.
  final double sleepHours;

  /// IANA timezone of the crew member.
  final String timezone;

  /// Overall wellness score 1–10.
  final int? wellnessScore;

  /// Stress level 1–10.
  final int? stressLevel;

  final String? notes;
  final DateTime? createdAt;

  bool get isHighFatigue => fatigueScore >= 7;
  bool get isLowSleep => sleepHours < 6.0;

  FatigueEntry copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? fatigueScore,
    double? sleepHours,
    String? timezone,
    int? wellnessScore,
    int? stressLevel,
    String? notes,
    DateTime? createdAt,
  }) {
    return FatigueEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      fatigueScore: fatigueScore ?? this.fatigueScore,
      sleepHours: sleepHours ?? this.sleepHours,
      timezone: timezone ?? this.timezone,
      wellnessScore: wellnessScore ?? this.wellnessScore,
      stressLevel: stressLevel ?? this.stressLevel,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FatigueEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
