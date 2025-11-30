part of 'list_bloc.dart';

class ListState extends Equatable {
  final List<Item>? items;
  final int? page;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? errorMessage;
  final String? loadMoreError;
  final String query;

  const ListState({
    this.items,
    this.page,
    required this.hasMore,
    required this.isLoading,
    required this.isLoadingMore,
    required this.isRefreshing,
    this.errorMessage,
    this.loadMoreError,
    required this.query,
  });

  factory ListState.initial() => ListState(
        items: null,
        page: null,
        hasMore: true,
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        errorMessage: null,
        loadMoreError: null,
        query: '',
      );

  factory ListState.loading({String query = ''}) => ListState(
        items: null,
        page: null,
        hasMore: true,
        isLoading: true,
        isLoadingMore: false,
        isRefreshing: false,
        errorMessage: null,
        loadMoreError: null,
        query: query,
      );

  factory ListState.success(
          {required List<Item> items,
          required int page,
          required bool hasMore,
          String query = ''}) =>
      ListState(
        items: items,
        page: page,
        hasMore: hasMore,
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        errorMessage: null,
        loadMoreError: null,
        query: query,
      );

  factory ListState.failure({required String message, String query = ''}) =>
      ListState(
        items: null,
        page: null,
        hasMore: true,
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        errorMessage: message,
        loadMoreError: null,
        query: query,
      );

  factory ListState.empty({String query = ''}) => ListState(
        items: [],
        page: 1,
        hasMore: false,
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        errorMessage: null,
        loadMoreError: null,
        query: query,
      );

  ListState copyWith({
    List<Item>? items,
    int? page,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? errorMessage,
    String? loadMoreError,
    String? query,
  }) {
    return ListState(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage ?? this.errorMessage,
      loadMoreError: loadMoreError ?? this.loadMoreError,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [
        items,
        page,
        hasMore,
        isLoading,
        isLoadingMore,
        isRefreshing,
        errorMessage,
        loadMoreError,
        query
      ];
}
