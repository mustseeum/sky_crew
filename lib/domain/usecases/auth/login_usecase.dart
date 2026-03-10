import '../../entities/user.dart';
import '../../../data/repositories/auth_repository.dart';

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
