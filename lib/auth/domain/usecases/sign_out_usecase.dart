import 'package:cleanarchexample/auth/data/repos/auth_repo_impl.dart';
import 'package:cleanarchexample/auth/domain/repos/auth_repo.dart';
import 'package:cleanarchexample/core/entities/failure.dart';
import 'package:cleanarchexample/core/usecase/usecase.dart';
import 'package:fpdart/src/either.dart';

class SignOutUsecase implements UseCase<bool, NoParams> {
  final IAuthRepository _authRepository;

  SignOutUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;
  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _authRepository.signOut();
  }
}
