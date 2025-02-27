import 'package:dartz/dartz.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Exception, User>> getUserById(String id);
  Future<Either<Exception, User>> getCurrentUser();
  Future<Either<Exception, bool>> updateUser(User user);
  Future<Either<Exception, bool>> login(String email, String password);
  Future<Either<Exception, bool>> register(
    String name,
    String email,
    String password,
  );
  Future<Either<Exception, bool>> logout();
}
