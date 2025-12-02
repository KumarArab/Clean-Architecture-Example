part of 'home_bloc.dart';

@immutable
final class HomeEvent {}

final class HomeFetchEmployeesEvent extends HomeEvent {
  final bool firstFetch;

  HomeFetchEmployeesEvent({
    this.firstFetch = false,
  });
}
