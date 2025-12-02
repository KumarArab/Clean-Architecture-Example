part of 'home_bloc.dart';

@immutable
sealed class HomeState {
  const HomeState();

  // Helper getter to extract employees from any state
  List<Employee> get employees {
    return switch (this) {
      HomeInitialState() => [],
      HomeLoadingState(employees: final employees) => employees,
      HomeErrorState(employees: final employees) => employees,
      HomePaginationErrorState(employees: final employees) => employees,
      HomeSuccesState(employees: final employees) => employees,
    };
  }
}

final class HomeInitialState extends HomeState {
  const HomeInitialState();
}

final class HomeLoadingState extends HomeState {
  final bool firstFetch;
  @override
  final List<Employee> employees;

  const HomeLoadingState({
    this.firstFetch = false,
    required this.employees,
  });
}

final class HomeErrorState extends HomeState {
  final String message;
  @override
  final List<Employee> employees;

  const HomeErrorState({
    required this.message,
    required this.employees,
  });
}

final class HomePaginationErrorState extends HomeState {
  final String message;
  @override
  final List<Employee> employees;

  const HomePaginationErrorState({
    required this.message,
    required this.employees,
  });
}

final class HomeSuccesState extends HomeState {
  @override
  final List<Employee> employees;

  const HomeSuccesState({required this.employees});
}
