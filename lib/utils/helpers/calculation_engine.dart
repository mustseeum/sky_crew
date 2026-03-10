import '../../domain/entities/flight_record.dart';
import 'date_time_helper.dart';

/// Aviation calculation engine for FTL (Flight Time Limitations) rules.
class CalculationEngine {
  CalculationEngine._();

  // ---------------------------------------------------------------------------
  // Block time
  // ---------------------------------------------------------------------------

  /// Calculates block time in minutes from departure to arrival.
  static int calculateBlockTimeMinutes(DateTime offBlocks, DateTime onBlocks) {
    if (onBlocks.isBefore(offBlocks)) {
      throw ArgumentError('On-blocks time must be after off-blocks time.');
    }
    return onBlocks.difference(offBlocks).inMinutes;
  }

  // ---------------------------------------------------------------------------
  // Totals
  // ---------------------------------------------------------------------------

  /// Sums block time for a list of records.
  static int totalBlockTimeMinutes(List<FlightRecord> records) =>
      records.fold(0, (sum, r) => sum + r.blockTimeMinutes);

  /// Sums duty time for a list of records.
  static int totalDutyTimeMinutes(List<FlightRecord> records) =>
      records.fold(0, (sum, r) => sum + r.dutyTimeMinutes);

  /// Sums night time for a list of records.
  static int totalNightTimeMinutes(List<FlightRecord> records) =>
      records.fold(0, (sum, r) => sum + r.nightTimeMinutes);

  /// Total landings across records.
  static int totalLandings(List<FlightRecord> records) =>
      records.fold(0, (sum, r) => sum + r.landings);

  // ---------------------------------------------------------------------------
  // Period summaries
  // ---------------------------------------------------------------------------

  /// Filters records to the current calendar month.
  static List<FlightRecord> filterThisMonth(List<FlightRecord> records) {
    final start = DateTimeHelper.startOfMonth();
    final end = DateTimeHelper.endOfMonth();
    return records.where((r) {
      return !r.date.isBefore(start) && !r.date.isAfter(end);
    }).toList();
  }

  /// Filters records to the current calendar year.
  static List<FlightRecord> filterThisYear(List<FlightRecord> records) {
    final start = DateTimeHelper.startOfYear();
    final end = DateTimeHelper.endOfYear();
    return records.where((r) {
      return !r.date.isBefore(start) && !r.date.isAfter(end);
    }).toList();
  }

  /// Filters records to the last 28 days (rolling).
  static List<FlightRecord> filterLast28Days(List<FlightRecord> records) {
    final from = DateTimeHelper.last28Days();
    return records.where((r) => r.date.isAfter(from)).toList();
  }

  /// Filters records to the last 90 days (rolling).
  static List<FlightRecord> filterLast90Days(List<FlightRecord> records) {
    final from = DateTimeHelper.last90Days();
    return records.where((r) => r.date.isAfter(from)).toList();
  }

  // ---------------------------------------------------------------------------
  // FTL compliance checks (EASA-based defaults)
  // ---------------------------------------------------------------------------

  /// Returns true if monthly hours comply (≤ 100 hours block time).
  static bool isMonthlyCompliant(List<FlightRecord> records) {
    final monthly = filterThisMonth(records);
    final totalMinutes = totalBlockTimeMinutes(monthly);
    return totalMinutes <= 100 * 60;
  }

  /// Returns true if yearly hours comply (≤ 900 hours block time).
  static bool isYearlyCompliant(List<FlightRecord> records) {
    final yearly = filterThisYear(records);
    final totalMinutes = totalBlockTimeMinutes(yearly);
    return totalMinutes <= 900 * 60;
  }

  // ---------------------------------------------------------------------------
  // Logbook summary model
  // ---------------------------------------------------------------------------

  static LogbookSummary generateSummary(List<FlightRecord> records) {
    final thisMonth = filterThisMonth(records);
    final thisYear = filterThisYear(records);
    final last28 = filterLast28Days(records);
    final last90 = filterLast90Days(records);

    return LogbookSummary(
      totalFlights: records.length,
      totalBlockMinutes: totalBlockTimeMinutes(records),
      totalDutyMinutes: totalDutyTimeMinutes(records),
      totalLandings: totalLandings(records),
      monthBlockMinutes: totalBlockTimeMinutes(thisMonth),
      yearBlockMinutes: totalBlockTimeMinutes(thisYear),
      last28BlockMinutes: totalBlockTimeMinutes(last28),
      last90BlockMinutes: totalBlockTimeMinutes(last90),
      isMonthlyCompliant: isMonthlyCompliant(records),
      isYearlyCompliant: isYearlyCompliant(records),
    );
  }
}

/// Aggregated logbook statistics.
class LogbookSummary {
  const LogbookSummary({
    required this.totalFlights,
    required this.totalBlockMinutes,
    required this.totalDutyMinutes,
    required this.totalLandings,
    required this.monthBlockMinutes,
    required this.yearBlockMinutes,
    required this.last28BlockMinutes,
    required this.last90BlockMinutes,
    required this.isMonthlyCompliant,
    required this.isYearlyCompliant,
  });

  final int totalFlights;
  final int totalBlockMinutes;
  final int totalDutyMinutes;
  final int totalLandings;
  final int monthBlockMinutes;
  final int yearBlockMinutes;
  final int last28BlockMinutes;
  final int last90BlockMinutes;
  final bool isMonthlyCompliant;
  final bool isYearlyCompliant;

  double get totalBlockHours => totalBlockMinutes / 60.0;
  double get monthBlockHours => monthBlockMinutes / 60.0;
  double get yearBlockHours => yearBlockMinutes / 60.0;
}
