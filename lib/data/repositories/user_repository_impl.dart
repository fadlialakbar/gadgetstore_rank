// import 'package:dartz/dartz.dart';
// import '../../domain/entities/user.dart';
// import '../../domain/repositories/user_repository.dart';
// import '../datasources/local/local_user_data_source.dart';
// import '../models/user_model.dart';

// class UserRepositoryImpl implements UserRepository {
//   final LocalUserDataSource localDataSource;

//   UserRepositoryImpl({required this.localDataSource});

//   @override
//   Future<Either<Exception, User>> getUserById(String id) async {
//     try {
//       final user = await localDataSource.getUserById(id);
//       if (user != null) {
//         return Right(user);
//       } else {
//         return Left(Exception('User not found'));
//       }
//     } on Exception catch (e) {
//       return Left(e);
//     }
//   }

//   @override
//   Future<Either<Exception, User>> getCurrentUser() async {
//     try {
//       final user = await localDataSource.getCurrentUser();
//       if (user != null) {
//         return Right(user);
//       } else {
//         return Left(Exception('No user is currently logged in'));
//       }
//     } on Exception catch (e) {
//       return Left(e);
//     }
//   }

//   @override
//   Future<Either<Exception, bool>> updateUser(User user) async {
//     try {
//       if (user is UserModel) {
//         final result = await localDataSource.updateUser(user);
//         return Right(result);
//       } else {
//         // Convert User to UserModel if needed
//         final userModel = UserModel(
//           id: user.id,
//           name: user.name,
//           imageUrl: user.imageUrl,
//           status: user.status ?? '',
//           statusMessage: user.statusMessage ?? '',
//           reviewCount: user.reviewCount,
//           joinDate: user.joinDate,
//         );
//         final result = await localDataSource.updateUser(userModel);
//         return Right(result);
//       }
//     } on Exception catch (e) {
//       return Left(e);
//     }
//   }

//   @override
//   Future<Either<Exception, bool>> login(String email, String password) async {
//     try {
//       final result = await localDataSource.login(email, password);
//       if (result) {
//         return const Right(true);
//       } else {
//         return Left(Exception('Invalid email or password'));
//       }
//     } on Exception catch (e) {
//       return Left(e);
//     }
//   }

//   @override
//   Future<Either<Exception, bool>> register(
//     String name,
//     String email,
//     String password,
//   ) async {
//     try {
//       final result = await localDataSource.register(name, email, password);
//       if (result) {
//         return const Right(true);
//       } else {
//         return Left(
//           Exception('Registration failed. Email may already be in use.'),
//         );
//       }
//     } on Exception catch (e) {
//       return Left(e);
//     }
//   }

//   @override
//   Future<Either<Exception, bool>> logout() async {
//     try {
//       final result = await localDataSource.logout();
//       return Right(result);
//     } on Exception catch (e) {
//       return Left(e);
//     }
//   }
// }
