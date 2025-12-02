import 'package:cleanarchexample/clean_architecture/core/entities/failure.dart';
import 'package:cleanarchexample/clean_architecture/home/domain/entities/employee.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class IHomeRepository {
  Future<Either<Failure, List<Employee>>> fetchEmployees(
      {required int limit, required int start});
  Future<Either<Failure, List<Employee>>> searchEmployees(
      {required String userId});
}
