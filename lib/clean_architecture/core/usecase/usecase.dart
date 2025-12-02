import 'package:cleanarchexample/clean_architecture/core/entities/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

abstract interface class UseCaseSync<SuccessType, Params> {
  Either<Failure, SuccessType> call(Params params);
}

class NoParams {}
