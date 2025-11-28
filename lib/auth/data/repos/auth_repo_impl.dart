import 'package:cleanarchexample/auth/data/datasources/data_source.dart';
import 'package:cleanarchexample/core/entities/user.dart';
import 'package:cleanarchexample/auth/domain/repos/auth_repo.dart';
import 'package:cleanarchexample/core/entities/failure.dart';
import 'package:cleanarchexample/core/exceptions/auth_exceptions.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepository implements IAuthRepository {
  final IDataSource _dataSource;

  AuthRepository({required IDataSource dataSource}) : _dataSource = dataSource;

  @override
  Either<Failure, User> getCurrentUser() {
    try {
      return right(_dataSource.getCurrentUser());
    } on AuthException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signup(
      {required String name,
      required String email,
      required String password}) async {
    try {
      return right(await _dataSource.signup(
          name: name, email: email, password: password));
    } catch (e) {
      return left(
        Failure(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, User>> login(
      {required String email, required String password}) async {
    try {
      return right(await _dataSource.login(email: email, password: password));
    } on AuthException catch (e) {
      return left(
        Failure(message: e.message),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    try {
      return right(await _dataSource.signOut());
    } on AuthException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
