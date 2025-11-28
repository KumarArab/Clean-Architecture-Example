import 'package:cleanarchexample/core/entities/user.dart';
import 'package:cleanarchexample/auth/domain/repos/auth_repo.dart';
import 'package:cleanarchexample/core/entities/failure.dart';
import 'package:cleanarchexample/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

class SignupUseCase implements UseCase<User, SignupUseCaseParams> {
  final IAuthRepository _authRepository;

  SignupUseCase({required IAuthRepository authRepository})
      : _authRepository = authRepository;
  @override
  Future<Either<Failure, User>> call(SignupUseCaseParams params) async {
    return await _authRepository.signup(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class SignupUseCaseParams {
  final String name;
  final String email;
  final String password;

  SignupUseCaseParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
