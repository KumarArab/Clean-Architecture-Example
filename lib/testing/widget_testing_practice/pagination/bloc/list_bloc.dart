import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../items_repo.dart';
import '../item.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final ItemRepository repo;
  final int pageSize;
  Timer? _debounceTimer;

  ListBloc({required this.repo, this.pageSize = 20})
      : super(ListState.initial()) {
    on<LoadInitial>(_onLoadInitial);
    on<RefreshList>(_onRefreshList);
    on<LoadNextPage>(_onLoadNextPage);
    on<QueryChanged>(_onQueryChanged, transformer: _debounceTransformer());
  }

  EventTransformer<QueryChanged> _debounceTransformer<QueryChanged>() {
    return (events, mapper) {
      return events
          .transform(_DebounceStreamTransformer<QueryChanged>(
              const Duration(milliseconds: 300)))
          .asyncExpand(mapper);
    };
  }

  Future<void> _onLoadInitial(LoadInitial e, Emitter<ListState> emit) async {
    emit(ListState.loading());
    try {
      final page = await repo.fetchItems(
          page: 1, pageSize: pageSize, query: state.query);
      if (page.items.isEmpty) {
        emit(ListState.empty(query: state.query));
      } else {
        emit(ListState.success(
            items: page.items,
            page: 1,
            hasMore: page.hasMore,
            query: state.query));
      }
    } catch (err) {
      emit(ListState.failure(message: err.toString(), query: state.query));
    }
  }

  Future<void> _onRefreshList(RefreshList e, Emitter<ListState> emit) async {
    emit(state.copyWith(isRefreshing: true));
    try {
      final page = await repo.fetchItems(
          page: 1, pageSize: pageSize, query: state.query);
      if (page.items.isEmpty) {
        emit(ListState.empty(query: state.query));
      } else {
        emit(ListState.success(
            items: page.items,
            page: 1,
            hasMore: page.hasMore,
            query: state.query));
      }
    } catch (err) {
      emit(state.copyWith(isRefreshing: false, errorMessage: err.toString()));
    }
  }

  Future<void> _onLoadNextPage(LoadNextPage e, Emitter<ListState> emit) async {
    if (!state.hasMore || state.isLoadingMore || state.errorMessage != null)
      return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = (state.page ?? 1) + 1;
      final page = await repo.fetchItems(
          page: nextPage, pageSize: pageSize, query: state.query);
      final all = <Item>[...(state.items ?? []), ...page.items];
      emit(ListState.success(
          items: all,
          page: nextPage,
          hasMore: page.hasMore,
          query: state.query));
    } catch (err) {
      emit(state.copyWith(isLoadingMore: false, loadMoreError: err.toString()));
    }
  }

  Future<void> _onQueryChanged(QueryChanged e, Emitter<ListState> emit) async {
    // when query changes, set query and load initial
    emit(ListState.loading(query: e.query));
    try {
      final page =
          await repo.fetchItems(page: 1, pageSize: pageSize, query: e.query);
      if (page.items.isEmpty) {
        emit(ListState.empty(query: e.query));
      } else {
        emit(ListState.success(
            items: page.items, page: 1, hasMore: page.hasMore, query: e.query));
      }
    } catch (err) {
      emit(ListState.failure(message: err.toString(), query: e.query));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}

class _DebounceStreamTransformer<T> extends StreamTransformerBase<T, T> {
  final Duration duration;

  _DebounceStreamTransformer(this.duration);

  @override
  Stream<T> bind(Stream<T> stream) {
    StreamController<T>? controller;
    StreamSubscription<T>? subscription;
    Timer? timer;

    controller = StreamController<T>(
      onListen: () {
        subscription = stream.listen(
          (event) {
            timer?.cancel();
            timer = Timer(duration, () {
              controller!.add(event);
            });
          },
          onError: (error, stackTrace) =>
              controller!.addError(error, stackTrace),
          onDone: () {
            timer?.cancel();
            controller!.close();
          },
          cancelOnError: false,
        );
      },
      onCancel: () {
        timer?.cancel();
        return subscription?.cancel();
      },
    );

    return controller.stream;
  }
}
