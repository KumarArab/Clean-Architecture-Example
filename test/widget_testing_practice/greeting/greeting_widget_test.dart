import 'dart:async';

import 'package:cleanarchexample/testing/widget_testing_practice/greeting/future_repo.dart';
import 'package:cleanarchexample/testing/widget_testing_practice/greeting/greeting_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRepo extends Mock implements FutureRepository {}

class TestKeys {
  static const loadingKey = Key('loading');
  static const errorKey = Key('error');
  static const dataKey = Key('data');
}

void main() {
  final MockRepo mockRepo = MockRepo();

  testWidgets('Loading state', (tester) async {
    Completer<String> completer = Completer<String>();

    when(() => mockRepo.fetchGreeting()).thenAnswer((_) => completer.future);
    await tester.pumpWidget(MaterialApp(
      home: GreetingWidget(repo: mockRepo),
    ));

    final circularProgressIndicatorFinder = find.byKey(TestKeys.loadingKey);

    final erroFinder = find.byKey(TestKeys.errorKey);
    final dataFinder = find.byKey(TestKeys.dataKey);

    expect(circularProgressIndicatorFinder, findsOneWidget);
    expect(erroFinder, findsNothing);
    expect(dataFinder, findsNothing);

    completer.complete("");
    await tester.pump();
  });

  testWidgets('Success state', (tester) async {
    Completer<String> completer = Completer<String>();

    when(() => mockRepo.fetchGreeting()).thenAnswer((_) => completer.future);
    await tester.pumpWidget(MaterialApp(
      home: GreetingWidget(repo: mockRepo),
    ));

    final circularProgressIndicatorFinder = find.byKey(TestKeys.loadingKey);

    expect(circularProgressIndicatorFinder, findsOneWidget);

    completer.complete("Hello World");
    await tester.pump();
    final dataFinder = find.byKey(TestKeys.dataKey);
    expect(dataFinder, findsOneWidget);

    final dataText = tester.widget<Center>(dataFinder);
    expect((dataText.child as Text).data, contains("Hello World"));
  });

  testWidgets('Error state', (tester) async {
    Completer<String> completer = Completer<String>();

    when(() => mockRepo.fetchGreeting()).thenAnswer((_) => completer.future);
    await tester.pumpWidget(MaterialApp(
      home: GreetingWidget(repo: mockRepo),
    ));

    final circularProgressIndicatorFinder = find.byKey(TestKeys.loadingKey);

    expect(circularProgressIndicatorFinder, findsOneWidget);

    completer.completeError(Exception('oops'));
    await tester.pump();
    final errorFinder = find.byKey(TestKeys.errorKey);
    expect(errorFinder, findsOneWidget);

    final dataText = tester.widget<Center>(errorFinder);
    expect((dataText.child as Text).data, contains("oops"));
  });
}
