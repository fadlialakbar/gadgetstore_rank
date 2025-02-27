import 'package:dartz/dartz.dart';
import '../../repositories/user_repository.dart';

class LoginUseCase {
  final UserRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Exception, bool>> execute(String email, String password) {
    return repository.login(email, password);
  }
}
