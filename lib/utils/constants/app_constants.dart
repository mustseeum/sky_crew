/// Application-wide constants.
abstract class AppConstants {
  AppConstants._();

  // Fatigue thresholds
  static const int highFatigueThreshold = 7;
  static const double lowSleepThreshold = 6.0;

  // License warning days
  static const int licenseWarningDays = 90;

  // Duty time limits (EASA FTL / typical values)
  static const int maxDailyDutyMinutes = 13 * 60; // 13 hours
  static const int maxMonthlyFlightMinutes = 100 * 60; // 100 hours
  static const int maxYearlyFlightMinutes = 900 * 60; // 900 hours
  static const int maxFlightDutyPeriodMinutes = 14 * 60; // 14 hours

  // Pagination
  static const int pageSize = 20;

  // Supported aircraft types
  static const List<String> commonAircraftTypes = [
    'B737',
    'B737 MAX',
    'B747',
    'B757',
    'B767',
    'B777',
    'B787',
    'A319',
    'A320',
    'A321',
    'A330',
    'A340',
    'A350',
    'A380',
    'ATR 42',
    'ATR 72',
    'CRJ 200',
    'CRJ 700',
    'CRJ 900',
    'E170',
    'E175',
    'E190',
    'E195',
    'DHC-8',
    'Q400',
  ];

  // Roles for pilots / flight crew
  static const List<String> crewRoles = [
    'Captain',
    'First Officer',
    'Second Officer',
    'Relief Captain',
    'Relief First Officer',
    'Purser',
    'Senior Cabin Crew',
    'Cabin Crew',
    'Supervisor',
  ];

  // Common ICAO airports (sample)
  static const List<String> commonAirports = [
    'VVTS', // Ho Chi Minh City
    'VVNB', // Hanoi
    'VVDN', // Da Nang
    'VTBS', // Bangkok Suvarnabhumi
    'WSSS', // Singapore
    'WMKK', // Kuala Lumpur
    'WIII', // Jakarta
    'RJTT', // Tokyo Haneda
    'RKSI', // Seoul Incheon
    'ZBAA', // Beijing Capital
    'ZSPD', // Shanghai Pudong
    'VHHH', // Hong Kong
    'EGLL', // London Heathrow
    'LFPG', // Paris CDG
    'EDDF', // Frankfurt
    'EHAM', // Amsterdam
    'KJFK', // New York JFK
    'KLAX', // Los Angeles
    'YSSY', // Sydney
    'OMDB', // Dubai
  ];

  // Timezone list (IANA)
  static const List<String> commonTimezones = [
    'Asia/Ho_Chi_Minh',
    'Asia/Bangkok',
    'Asia/Singapore',
    'Asia/Jakarta',
    'Asia/Tokyo',
    'Asia/Seoul',
    'Asia/Shanghai',
    'Asia/Hong_Kong',
    'Asia/Dubai',
    'Europe/London',
    'Europe/Paris',
    'America/New_York',
    'America/Los_Angeles',
    'Australia/Sydney',
    'UTC',
  ];
}
