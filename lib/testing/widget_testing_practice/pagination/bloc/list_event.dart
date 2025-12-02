part of 'list_bloc.dart';

abstract class ListEvent {}

class LoadInitial extends ListEvent {}

class RefreshList extends ListEvent {}

class LoadNextPage extends ListEvent {}

class QueryChanged extends ListEvent {
  final String query;
  QueryChanged(this.query);
}
