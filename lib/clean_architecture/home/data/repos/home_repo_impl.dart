import 'package:cleanarchexample/clean_architecture/core/data/network_repo.dart';
import 'package:cleanarchexample/clean_architecture/core/entities/failure.dart';
import 'package:cleanarchexample/clean_architecture/home/data/models/employee_model.dart';
import 'package:cleanarchexample/clean_architecture/home/domain/entities/employee.dart';
import 'package:cleanarchexample/clean_architecture/home/domain/repos/home_repo.dart';
import 'package:fpdart/src/either.dart';

class HomeRepository implements IHomeRepository {
  final INetworkRepository _networkRepository;

  HomeRepository({required INetworkRepository networkRepository})
      : _networkRepository = networkRepository;
  @override
  Future<Either<Failure, List<Employee>>> fetchEmployees(
      {required int limit, required int start}) async {
    try {
      final res = await _networkRepository.makeRequest(
        method: Method.get,
        queryParams: {"_limit": limit, "_start": start},
        endPoint: "/posts",
        baseUrl: "https://jsonplaceholder.typicode.com",
      );

      // Parse the JSON list into List<EmployeeModel> using Freezed's fromJsonList
      if (res is List) {
        final employees = EmployeeModel.fromJsonList(res);
        return right(employees);
      } else {
        // If the response is not a list, return empty list or handle error
        return left(Failure(message: "Invalid response format"));
      }
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Employee>>> searchEmployees(
      {required String userId}) {
    // TODO: implement searchEmployees
    throw UnimplementedError();
  }
}
