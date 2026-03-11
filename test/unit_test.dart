import 'package:flutter_test/flutter_test.dart';

import 'package:sky_crew/utils/helpers/calculation_engine.dart';
import 'package:sky_crew/utils/helpers/date_time_helper.dart';
import 'package:sky_crew/utils/helpers/validation_helper.dart';
import 'package:sky_crew/domain/entities/flight_record.dart';
import 'package:sky_crew/domain/entities/license.dart';
import 'package:sky_crew/domain/entities/fatigue_entry.dart';

void main() {
  // ---------------------------------------------------------------------------
  // DateTimeHelper tests
  // ---------------------------------------------------------------------------
  group('DateTimeHelper', () {
    test('formatMinutes formats correctly', () {
      expect(DateTimeHelper.formatMinutes(0), '0h 00m');
      expect(DateTimeHelper.formatMinutes(60), '1h 00m');
      expect(DateTimeHelper.formatMinutes(90), '1h 30m');
      expect(DateTimeHelper.formatMinutes(125), '2h 05m');
    });

    test('formatMinutes handles negative input', () {
      expect(DateTimeHelper.formatMinutes(-1), '0h 00m');
    });
  });

  // ---------------------------------------------------------------------------
  // ValidationHelper tests
  // ---------------------------------------------------------------------------
  group('ValidationHelper', () {
    test('validateEmail rejects invalid emails', () {
      expect(ValidationHelper.validateEmail(''), isNotNull);
      expect(ValidationHelper.validateEmail('notanemail'), isNotNull);
      expect(ValidationHelper.validateEmail('missing@domain'), isNotNull);
    });

    test('validateEmail accepts valid emails', () {
      expect(ValidationHelper.validateEmail('user@airline.com'), isNull);
      expect(ValidationHelper.validateEmail('captain.john@sky.aero'), isNull);
    });

    test('validatePassword rejects short passwords', () {
      expect(ValidationHelper.validatePassword('abc'), isNotNull);
      expect(ValidationHelper.validatePassword('1234567'), isNotNull);
    });

    test('validatePassword accepts 8+ char passwords', () {
      expect(ValidationHelper.validatePassword('SecureP@ss'), isNull);
    });

    test('validateSleepHours rejects out-of-range values', () {
      expect(ValidationHelper.validateSleepHours('-1'), isNotNull);
      expect(ValidationHelper.validateSleepHours('25'), isNotNull);
    });

    test('validateSleepHours accepts valid range', () {
      expect(ValidationHelper.validateSleepHours('7'), isNull);
      expect(ValidationHelper.validateSleepHours('0'), isNull);
    });

    test('validateFatigueScore rejects out-of-range values', () {
      expect(ValidationHelper.validateFatigueScore('0'), isNotNull);
      expect(ValidationHelper.validateFatigueScore('11'), isNotNull);
    });

    test('validateFatigueScore accepts 1-10', () {
      expect(ValidationHelper.validateFatigueScore('5'), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // CalculationEngine tests
  // ---------------------------------------------------------------------------
  group('CalculationEngine', () {
    FlightRecord makeRecord({
      required DateTime date,
      int blockMinutes = 90,
      int dutyMinutes = 300,
      int landings = 1,
    }) {
      return FlightRecord(
        id: 'test-${date.millisecondsSinceEpoch}',
        userId: 'user1',
        date: date,
        flightNumber: 'VN100',
        departureAirport: 'VVTS',
        arrivalAirport: 'VVNB',
        aircraftType: 'A320',
        aircraftRegistration: 'VN-A100',
        blockTimeMinutes: blockMinutes,
        dutyTimeMinutes: dutyMinutes,
        role: 'Captain',
        landings: landings,
      );
    }

    test('totalBlockTimeMinutes sums correctly', () {
      final records = [
        makeRecord(date: DateTime.now(), blockMinutes: 90),
        makeRecord(date: DateTime.now(), blockMinutes: 60),
      ];
      expect(CalculationEngine.totalBlockTimeMinutes(records), 150);
    });

    test('totalLandings sums correctly', () {
      final records = [
        makeRecord(date: DateTime.now(), landings: 2),
        makeRecord(date: DateTime.now(), landings: 3),
      ];
      expect(CalculationEngine.totalLandings(records), 5);
    });

    test('calculateBlockTimeMinutes calculates difference', () {
      final offBlocks = DateTime(2024, 1, 1, 10, 0);
      final onBlocks = DateTime(2024, 1, 1, 12, 30);
      expect(
        CalculationEngine.calculateBlockTimeMinutes(offBlocks, onBlocks),
        150,
      );
    });

    test('calculateBlockTimeMinutes throws on invalid times', () {
      final offBlocks = DateTime(2024, 1, 1, 12, 0);
      final onBlocks = DateTime(2024, 1, 1, 10, 0);
      expect(
        () => CalculationEngine.calculateBlockTimeMinutes(
            offBlocks, onBlocks),
        throwsArgumentError,
      );
    });

    test('isMonthlyCompliant returns false when over 100h', () {
      // 101 hours = 6060 minutes
      final records = [
        makeRecord(
          date: DateTime.now(),
          blockMinutes: 6060,
        ),
      ];
      expect(CalculationEngine.isMonthlyCompliant(records), isFalse);
    });

    test('isMonthlyCompliant returns true under 100h', () {
      final records = [
        makeRecord(
          date: DateTime.now(),
          blockMinutes: 300,
        ),
      ];
      expect(CalculationEngine.isMonthlyCompliant(records), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // Domain entity tests
  // ---------------------------------------------------------------------------
  group('License entity', () {
    test('isExpired returns true for past expiry', () {
      final license = License(
        id: '1',
        userId: 'u1',
        type: 'ATPL',
        number: 'VN-001',
        issuingAuthority: 'CAAV',
        issueDate: DateTime(2020, 1, 1),
        expiryDate: DateTime(2021, 1, 1),
      );
      expect(license.isExpired, isTrue);
    });

    test('isExpiringSoon returns true within 90 days', () {
      final license = License(
        id: '1',
        userId: 'u1',
        type: 'ATPL',
        number: 'VN-001',
        issuingAuthority: 'CAAV',
        issueDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 30)),
      );
      expect(license.isExpiringSoon, isTrue);
      expect(license.isExpired, isFalse);
    });
  });

  group('FatigueEntry entity', () {
    test('isHighFatigue returns true for score >= 7', () {
      final entry = FatigueEntry(
        id: '1',
        userId: 'u1',
        date: DateTime(2024, 1, 1),
        fatigueScore: 7,
        sleepHours: 5.0,
        timezone: 'UTC',
      );
      expect(entry.isHighFatigue, isTrue);
    });

    test('isLowSleep returns true for sleep < 6h', () {
      final entry = FatigueEntry(
        id: '1',
        userId: 'u1',
        date: DateTime(2024, 1, 1),
        fatigueScore: 3,
        sleepHours: 5.5,
        timezone: 'UTC',
      );
      expect(entry.isLowSleep, isTrue);
    });
  });
}
