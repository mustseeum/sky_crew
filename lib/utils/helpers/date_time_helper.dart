import 'package:intl/intl.dart';

/// Helper utilities for date and time formatting.
class DateTimeHelper {
  DateTimeHelper._();

  static final _dateFormat = DateFormat('dd MMM yyyy');
  static final _shortDateFormat = DateFormat('dd/MM/yyyy');
  static final _timeFormat = DateFormat('HH:mm');
  static final _dateTimeFormat = DateFormat('dd MMM yyyy, HH:mm');
  static final _monthYearFormat = DateFormat('MMM yyyy');

  static String formatDate(DateTime date) => _dateFormat.format(date);
  static String formatShortDate(DateTime date) =>
      _shortDateFormat.format(date);
  static String formatTime(DateTime time) => _timeFormat.format(time);
  static String formatDateTime(DateTime dt) => _dateTimeFormat.format(dt);
  static String formatMonthYear(DateTime date) =>
      _monthYearFormat.format(date);

  /// Formats minutes to "Xh Ym" display string (e.g., 125 → "2h 05m").
  static String formatMinutes(int totalMinutes) {
    if (totalMinutes < 0) return '0h 00m';
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }

  /// Formats hours as decimal to "Xh Ym" (e.g., 2.5 → "2h 30m").
  static String formatHours(double hours) {
    return formatMinutes((hours * 60).round());
  }

  /// Returns the start of the current month.
  static DateTime startOfMonth([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateTime(d.year, d.month, 1);
  }

  /// Returns the end of the current month.
  static DateTime endOfMonth([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateTime(d.year, d.month + 1, 0, 23, 59, 59);
  }

  /// Returns the start of the current year.
  static DateTime startOfYear([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateTime(d.year, 1, 1);
  }

  /// Returns the end of the current year.
  static DateTime endOfYear([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateTime(d.year, 12, 31, 23, 59, 59);
  }

  /// Returns the start of the last 28 days.
  static DateTime last28Days() =>
      DateTime.now().subtract(const Duration(days: 28));

  /// Returns the start of the last 90 days.
  static DateTime last90Days() =>
      DateTime.now().subtract(const Duration(days: 90));

  /// Returns the number of days between two dates.
  static int daysBetween(DateTime from, DateTime to) =>
      to.difference(from).inDays.abs();

  /// Returns a relative time string (e.g., "2 days ago").
  static String relativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()} year(s) ago';
    } else if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()} month(s) ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} day(s) ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour(s) ago';
    } else {
      return 'Just now';
    }
  }
}
