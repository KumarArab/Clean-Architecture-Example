import 'package:cleanarchexample/testing/widget_testing_practice/pagination/bloc/list_bloc.dart';
import 'package:cleanarchexample/testing/widget_testing_practice/pagination/item.dart';
import 'package:cleanarchexample/testing/widget_testing_practice/pagination/items_repo.dart';
import 'package:cleanarchexample/testing/widget_testing_practice/pagination/list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cleanarchexample/testing/widget_testing_practice/pagination/page.dart'
    as page;

class MockItemsRepo extends Mock implements ItemRepository {}

class MockListBloc extends Mock implements ListBloc {}

class FakeListEvent extends Fake implements ListEvent {}

class FakeListState extends Fake implements ListState {}

class TestKeys {
  static const loadingKey = Key("loading");
  static const emptyKey = Key("empty");
  static const errorKey = Key("error");
  static const listviewKey = Key("listView");
}

void main() {
  late MockItemsRepo repo;

  setUp(() {
    repo = MockItemsRepo();
  });

  group("inital Loadup", () {
    testWidgets('Initial State', (tester) async {
      final bloc = ListBloc(repo: repo);
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => bloc,
          child: ListScreen(),
        ),
      ));

      when(() => repo.fetchItems(
                page: any(named: "page"),
                pageSize: any(named: "pageSize"),
                query: any(named: "query"),
              ))
          .thenAnswer((_) async =>
              await Future.delayed(Duration(milliseconds: 200), () {
                return page.Page(
                  items: [],
                  hasMore: false,
                );
              }));

      // bloc.add(LoadInitial());
      bloc.add(LoadInitial());
      await tester.pump();
      final circularProgressIndicatorFinder = find.byKey(TestKeys.loadingKey);
      expect(circularProgressIndicatorFinder, findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('InitialLoad complete with no items state', (tester) async {
      final bloc = ListBloc(repo: repo);
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => bloc,
          child: ListScreen(),
        ),
      ));

      when(() => repo.fetchItems(
                page: any(named: "page"),
                pageSize: any(named: "pageSize"),
                query: any(named: "query"),
              ))
          .thenAnswer((_) async =>
              await Future.delayed(Duration(milliseconds: 200), () {
                return page.Page(
                  items: [],
                  hasMore: false,
                );
              }));

      // bloc.add(LoadInitial());
      bloc.add(LoadInitial());
      await tester.pump();
      final circularProgressIndicatorFinder = find.byKey(TestKeys.loadingKey);
      expect(circularProgressIndicatorFinder, findsOneWidget);
      await tester.pumpAndSettle();
      final emptyWidgetFinder = find.byKey(TestKeys.emptyKey);
      expect(emptyWidgetFinder, findsOneWidget);
      await tester.pumpAndSettle();
    });
    testWidgets('InitialLoad complete with items state', (tester) async {
      List<Item> items = List.generate(
        10,
        (i) => Item(id: "$i", title: "title$i", subtitle: "$i"),
      );
      final bloc = ListBloc(repo: repo);
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => bloc,
          child: ListScreen(),
        ),
      ));

      when(() => repo.fetchItems(
                page: any(named: "page"),
                pageSize: any(named: "pageSize"),
                query: any(named: "query"),
              ))
          .thenAnswer((_) async =>
              await Future.delayed(Duration(milliseconds: 200), () {
                return page.Page(
                  items: items,
                  hasMore: false,
                );
              }));

      // bloc.add(LoadInitial());
      bloc.add(LoadInitial());
      await tester.pump();
      final circularProgressIndicatorFinder = find.byKey(TestKeys.loadingKey);
      expect(circularProgressIndicatorFinder, findsOneWidget);
      await tester.pumpAndSettle();
      final listviewfinder = find.byKey(TestKeys.listviewKey);
      expect(listviewfinder, findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('InitialLoad complete with error state', (tester) async {
      final bloc = ListBloc(repo: repo);
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => bloc,
          child: ListScreen(),
        ),
      ));

      when(() => repo.fetchItems(
                page: any(named: "page"),
                pageSize: any(named: "pageSize"),
                query: any(named: "query"),
              ))
          .thenAnswer((_) async =>
              await Future.delayed(Duration(milliseconds: 200), () {
                return Future.error(Exception("something went wrong"));
              }));

      // bloc.add(LoadInitial());
      bloc.add(LoadInitial());
      await tester.pump();
      final circularProgressIndicatorFinder = find.byKey(TestKeys.loadingKey);
      expect(circularProgressIndicatorFinder, findsOneWidget);
      await tester.pumpAndSettle();
      final errorFinder = find.byKey(TestKeys.errorKey);
      expect(errorFinder, findsOneWidget);
      await tester.pumpAndSettle();
    });
  });
}
