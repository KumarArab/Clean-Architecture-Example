import 'package:bloc/bloc.dart';
import 'package:cleanarchexample/clean_architecture/home/domain/entities/employee.dart';
import 'package:cleanarchexample/clean_architecture/home/domain/usecases/fetch_employees_usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchEmployeesUsecase _fetchEmployeesUsecase;

  HomeBloc({required FetchEmployeesUsecase fetchEmployeeUsecase})
      : _fetchEmployeesUsecase = fetchEmployeeUsecase,
        super(const HomeInitialState()) {
    on<HomeFetchEmployeesEvent>(_handleEmployeeFetch);
  }

  _handleEmployeeFetch(HomeFetchEmployeesEvent event, Emitter emit) async {
    if (state is HomeLoadingState) return;
    // Get current employees from the previous state
    final currentEmployees = state.employees;

    emit(HomeLoadingState(
      firstFetch: event.firstFetch,
      employees: currentEmployees,
    ));

    final res = await _fetchEmployeesUsecase.call(FetchEmployeeParams(
      limit: 10,
      start: state.employees.length,
    ));

    res.fold((l) {
      if (event.firstFetch) {
        emit(HomeErrorState(
          message: l.message,
          employees: currentEmployees,
        ));
      } else {
        emit(HomePaginationErrorState(
          message: l.message,
          employees: currentEmployees,
        ));
      }
    }, (r) {
      // Create new list with appended employees
      final updatedEmployees = [...currentEmployees, ...r];
      emit(HomeSuccesState(employees: updatedEmployees));
    });
  }
}
