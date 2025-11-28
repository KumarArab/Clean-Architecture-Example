import 'package:cleanarchexample/core/entities/user.dart';
import 'package:cleanarchexample/auth/domain/repos/auth_repo.dart';
import 'package:cleanarchexample/core/entities/failure.dart';
import 'package:cleanarchexample/core/usecase/usecase.dart';
import 'package:fpdart/src/either.dart';

class CurrentUserUseCase implements UseCaseSync<User, NoParams> {
  final IAuthRepository _authRepository;

  CurrentUserUseCase({required IAuthRepository authRepository})
      : _authRepository = authRepository;
  @override
  Either<Failure, User> call(NoParams params) {
    return _authRepository.getCurrentUser();
  }
}
