import '../../entities/user.dart';
import '../../../data/repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> execute({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? employeeId,
    String? airline,
    String? baseAirport,
  }) async {
    return _repository.register(
      email: email,
      password: password,
      name: name,
      role: role,
      employeeId: employeeId,
      airline: airline,
      baseAirport: baseAirport,
    );
  }
}
