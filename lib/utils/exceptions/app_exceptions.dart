/// Base exception class for SkyCrew application errors.
class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'AppException($code): $message';
}

/// Thrown when authentication fails.
class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

/// Thrown when a database operation fails.
class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code});
}

/// Thrown when a network request fails.
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

/// Thrown when validation fails.
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
}

/// Thrown when an export operation fails.
class ExportException extends AppException {
  const ExportException(super.message, {super.code});
}
