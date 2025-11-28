import 'package:cleanarchexample/core/entities/user.dart';
import 'package:cleanarchexample/core/entities/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class IAuthRepository {
  Either<Failure, User> getCurrentUser();
  Future<Either<Failure, bool>> signOut();
  Future<Either<Failure, User>> signup(
      {required String name, required String email, required String password});
  Future<Either<Failure, User>> login(
      {required String email, required String password});
}
