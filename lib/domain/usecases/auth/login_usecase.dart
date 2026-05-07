import 'package:sky_crew/domain/entities/user.dart';
import 'package:sky_crew/data/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> execute({
    required String email,
    required String password,
  }) async {
    return _repository.login(email: email, password: password);
  }
}
