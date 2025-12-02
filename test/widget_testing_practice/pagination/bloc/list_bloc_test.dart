import 'package:bloc_test/bloc_test.dart';
import 'package:cleanarchexample/testing/widget_testing_practice/pagination/bloc/list_bloc.dart';
import 'package:cleanarchexample/testing/widget_testing_practice/pagination/item.dart';
import 'package:cleanarchexample/testing/widget_testing_practice/pagination/items_repo.dart';
import 'package:cleanarchexample/testing/widget_testing_practice/pagination/page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockItemsRepo extends Mock implements ItemRepository {}

void main() {
  late MockItemsRepo repo;

  setUp(() {
    repo = MockItemsRepo();
  });
  {
    List<Item> items = List.generate(
      10,
      (i) => Item(id: "$i", title: "title$i", subtitle: "$i"),
    );
    blocTest(
      'Load initial',
      build: () => ListBloc(repo: repo),
      setUp: () {
        when(() => repo.fetchItems(
              page: any(named: "page"),
              pageSize: any(named: "pageSize"),
              query: any(named: "query"),
            )).thenAnswer((_) async => Page(items: items, hasMore: true));
      },
      act: (bloc) => bloc.add(LoadInitial()),
      expect: () => [
        ListState.loading(),
        ListState.success(
          items: items,
          page: 1,
          hasMore: true,
        ),
      ],
    );
  }
  {
    const errorMessage = "Something went wrong";
    blocTest(
      'Load initial with Failure',
      build: () => ListBloc(repo: repo),
      setUp: () {
        when(() => repo.fetchItems(
              page: any(named: "page"),
              pageSize: any(named: "pageSize"),
              query: any(named: "query"),
            )).thenAnswer((_) async => throw Exception(errorMessage));
      },
      act: (bloc) => bloc.add(LoadInitial()),
      expect: () => [
        ListState.loading(),
        ListState.failure(message: "Exception: $errorMessage"),
      ],
    );
  }

  group('Load next page', () {
    const errorMessage = "Something went wrong";

    List<Item> items = List.generate(
      10,
      (i) => Item(id: "$i", title: "title$i", subtitle: "$i"),
    );

    List<Item> newitems = List.generate(
      10,
      (i) =>
          Item(id: "${i + 10}", title: "title${i + 10}", subtitle: "${i + 10}"),
    );

    blocTest(
      'Happy Case',
      build: () => ListBloc(repo: repo),
      seed: () => ListState.success(items: items, page: 1, hasMore: true),
      setUp: () {
        when(() => repo.fetchItems(
              page: any(named: "page"),
              pageSize: any(named: "pageSize"),
              query: any(named: "query"),
            )).thenAnswer((_) async => Page(items: newitems, hasMore: true));
      },
      act: (bloc) => bloc.add(LoadNextPage()),
      verify: (bloc) {
        verify(() => repo.fetchItems(
              page: any(named: "page"),
              pageSize: any(named: "pageSize"),
              query: any(named: "query"),
            )).called(1);
      },
      expect: () => [
        ListState.success(items: [
          ...items,
        ], page: 1, hasMore: true)
            .copyWith(isLoadingMore: true),
        ListState.success(
            items: [...items, ...newitems], page: 2, hasMore: true)
      ],
    );

    blocTest(
      "Failure Case",
      build: () => ListBloc(repo: repo),
      seed: () => ListState.success(items: items, page: 1, hasMore: true),
      setUp: () {
        when(() => repo.fetchItems(
              page: any(named: "page"),
              pageSize: any(named: "pageSize"),
              query: any(named: "query"),
            )).thenAnswer((_) async => throw Exception(errorMessage));
      },
      act: (bloc) => bloc.add(LoadNextPage()),
      expect: () => [
        predicate<ListState>((s) => s.isLoadingMore == true),
        predicate<ListState>((s) =>
            s.isLoadingMore == false &&
            s.loadMoreError == "Exception: $errorMessage"),
      ],
    );

    blocTest(
      'If state does not have more',
      build: () => ListBloc(repo: repo),
      seed: () => ListState.success(items: items, page: 2, hasMore: false),
      setUp: () {
        when(() => repo.fetchItems(
              page: any(named: "page"),
              pageSize: any(named: "pageSize"),
              query: any(named: "query"),
            )).thenAnswer((_) async => throw Exception(errorMessage));
      },
      act: (bloc) => bloc.add(LoadNextPage()),
      verify: (bloc) {
        verifyNever(() => bloc.repo.fetchItems(
            page: any(named: "page"), pageSize: any(named: "pageSize")));
      },
      expect: () => [],
    );
  });

  {
    blocTest(
      "QueryChanged",
      build: () => ListBloc(
        repo: repo,
      ),
      setUp: () {
        when(() => repo.fetchItems(
              page: any(named: "page"),
              pageSize: any(named: "pageSize"),
              query: any(named: "query"),
            )).thenAnswer(
          (_) async => await Future.delayed(Duration(milliseconds: 200), () {
            return Page(items: [], hasMore: false);
          }),
        );
      },
      act: (bloc) {
        bloc.add(QueryChanged("m"));
        bloc.add(QueryChanged("mo"));
        bloc.add(QueryChanged("mom"));
        bloc.add(QueryChanged("momm"));
        bloc.add(QueryChanged("mommy"));
      },
      wait: const Duration(
          milliseconds:
              600), // Wait for debounce (300ms) + API call (200ms) + buffer
      expect: () => [
        ListState.loading(query: "mommy"),
        ListState.empty(query: "mommy"),
      ],
    );
  }
}
