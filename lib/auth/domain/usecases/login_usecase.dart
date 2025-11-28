import 'package:cleanarchexample/core/entities/user.dart';
import 'package:cleanarchexample/auth/domain/repos/auth_repo.dart';
import 'package:cleanarchexample/core/entities/failure.dart';
import 'package:cleanarchexample/core/usecase/usecase.dart';
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
