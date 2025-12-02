import 'dart:math';

import 'package:cleanarchexample/testing/unit_testing_practice/simple_async_tests.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SimpleAsync simpleAsync;
  setUp(() {
    simpleAsync = SimpleAsync();
  });
  group("Simple Async Tests", () {
    test('fetch value', () async {
      final res = await simpleAsync.fetchValue();
      expect(res, "hello");
    });

    test('fetchThatFails', () async {
      await expectLater(
          simpleAsync.fetchThatFails(), throwsA(isA<FormatException>()));
    });

    test('retryFetch', () async {
      int calls = 0;
      Future<int> remote() async {
        calls++;
        if (calls < 3) throw Exception("fail");
        return 42;
      }

      final res = await simpleAsync.retryingFetch(remote, retries: 3);
      expect(res, 42);
      expect(calls, 3);
    });
    test('fetchFullProfile', () async {
      final res = await simpleAsync.fetchFullProfile();
      expect(res, "Alice is 25 years old");
    });
  });
}
