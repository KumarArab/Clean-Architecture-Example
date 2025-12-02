import 'package:cleanarchexample/clean_architecture/core/entities/failure.dart';
import 'package:cleanarchexample/clean_architecture/core/usecase/usecase.dart';
import 'package:cleanarchexample/clean_architecture/home/domain/entities/employee.dart';
import 'package:cleanarchexample/clean_architecture/home/domain/repos/home_repo.dart';
import 'package:fpdart/fpdart.dart';

class FetchEmployeesUsecase
    implements UseCase<List<Employee>, FetchEmployeeParams> {
  final IHomeRepository _homeRepository;

  FetchEmployeesUsecase({required IHomeRepository homeRepository})
      : _homeRepository = homeRepository;
  @override
  Future<Either<Failure, List<Employee>>> call(params) async {
    return await _homeRepository.fetchEmployees(
      limit: params.limit,
      start: params.start,
    );
  }
}

class FetchEmployeeParams {
  final int limit;
  final int start;

  FetchEmployeeParams({
    this.limit = 0,
    this.start = 10,
  });
}
