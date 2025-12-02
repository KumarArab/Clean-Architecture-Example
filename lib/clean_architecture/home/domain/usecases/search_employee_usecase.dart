import 'package:cleanarchexample/clean_architecture/core/entities/failure.dart';
import 'package:cleanarchexample/clean_architecture/core/usecase/usecase.dart';
import 'package:cleanarchexample/clean_architecture/home/domain/entities/employee.dart';
import 'package:cleanarchexample/clean_architecture/home/domain/repos/home_repo.dart';
import 'package:fpdart/fpdart.dart';

class SearchEmployeesUsecase
    implements UseCase<List<Employee>, SearchEmployeeParams> {
  final IHomeRepository _homeRepository;

  SearchEmployeesUsecase({required IHomeRepository homeRepository})
      : _homeRepository = homeRepository;
  @override
  Future<Either<Failure, List<Employee>>> call(params) async {
    return await _homeRepository.searchEmployees(userId: params.userId);
  }
}

class SearchEmployeeParams {
  final String userId;

  SearchEmployeeParams({
    this.userId = "",
  });
}
