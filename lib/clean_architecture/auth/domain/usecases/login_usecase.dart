import 'package:cleanarchexample/clean_architecture/core/entities/user.dart';
import 'package:cleanarchexample/clean_architecture/auth/domain/repos/auth_repo.dart';
import 'package:cleanarchexample/clean_architecture/core/entities/failure.dart';
import 'package:cleanarchexample/clean_architecture/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

class LoginUseCase implements UseCase<User, LoginUseCaseParams> {
  final IAuthRepository _authRepository;

  LoginUseCase({required IAuthRepository authRepository})
      : _authRepository = authRepository;
  @override
  Future<Either<Failure, User>> call(LoginUseCaseParams params) async {
    return await _authRepository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginUseCaseParams {
  final String email;
  final String password;

  LoginUseCaseParams({
    required this.email,
    required this.password,
  });
}
