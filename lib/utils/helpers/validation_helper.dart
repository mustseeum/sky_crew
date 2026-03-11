/// Centralised input validation helpers.
class ValidationHelper {
  ValidationHelper._();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    final baseError = validatePassword(value);
    if (baseError != null) return baseError;
    if (value != password) return 'Passwords do not match.';
    return null;
  }

  static String? validateRequired(String? value, {String field = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required.';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required.';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters.';
    }
    return null;
  }

  static String? validateFlightNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Flight number is required.';
    }
    return null;
  }

  static String? validateAirportCode(String? value, {String field = 'Airport'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field code is required.';
    }
    if (value.trim().length < 3 || value.trim().length > 4) {
      return '$field must be a valid 3-4 character ICAO/IATA code.';
    }
    return null;
  }

  static String? validatePositiveNumber(String? value, {String field = 'Value'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required.';
    }
    final number = double.tryParse(value.trim());
    if (number == null) return '$field must be a number.';
    if (number < 0) return '$field must be positive.';
    return null;
  }

  static String? validateFatigueScore(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Fatigue score is required.';
    }
    final score = int.tryParse(value.trim());
    if (score == null || score < 1 || score > 10) {
      return 'Fatigue score must be between 1 and 10.';
    }
    return null;
  }

  static String? validateSleepHours(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Sleep hours is required.';
    }
    final hours = double.tryParse(value.trim());
    if (hours == null || hours < 0 || hours > 24) {
      return 'Sleep hours must be between 0 and 24.';
    }
    return null;
  }
}
