import 'dart:math';

import 'package:cleanarchexample/unit_testing_practice/mock_tests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements ApiService {}

class MockCacheService extends Mock implements CacheService {}

class MockLogger extends Mock implements Logger {}

class MockCallbackService extends Mock implements CallbackService {}

void main() {
  late MockApiService mockApiService;
  late MockCacheService mockCacheService;
  late MockLogger mockLogger;
  late MockCallbackService mockCallbackService;
  late MockingExamples mockingExamples;

  setUp(() {
    mockApiService = MockApiService();
    mockCacheService = MockCacheService();
    mockLogger = MockLogger();
    mockCallbackService = MockCallbackService();
    mockingExamples = MockingExamples(
      api: mockApiService,
      cache: mockCacheService,
      logger: mockLogger,
      callbackService: mockCallbackService,
    );
  });

  group('Mock Tests', () {
    test('getUserName', () async {
      final int id = 123;
      final String username = "lol";

      when(() => mockApiService.fetchUserName(id))
          .thenAnswer((_) async => username);
      final res = await mockingExamples.getUserName(id);

      expect(res, username);
    });

    group("getCachedOrFetched- ", () {
      test('cached', () async {
        final int id = 123;
        final String username = "lol";

        when(() => mockCacheService.read(any())).thenReturn(username);

        final res = await mockingExamples.getCachedOrFetch(id);

        verify(() => mockCacheService.read(any<String>())).called(1);
        verifyNever(() => mockApiService.fetchUserName(any<int>()));
        verifyNever(() => mockCacheService.write(any<String>(), any<String>()));
        expect(res, username);
      });

      test('cached throws synchronously', () {
        // Example: thenThrow is used for SYNCHRONOUS methods that throw
        // Since read() is synchronous (returns String?, not Future<String?>)
        when(() => mockCacheService.read(any()))
            .thenThrow(StateError('Cache corrupted'));

        // The exception is thrown immediately (synchronously)
        expect(() => mockCacheService.read('key'), throwsA(isA<StateError>()));
      });

      test('fetched', () async {
        final int id = 123;
        final String username = "lol";

        when(() => mockCacheService.read(any())).thenReturn(null);
        when(() => mockCacheService.write(any<String>(), any<String>()))
            .thenAnswer((_) async {});

        when(() => mockApiService.fetchUserName(id))
            .thenAnswer((_) async => username);

        final res = await mockingExamples.getCachedOrFetch(id);

        verify(() => mockCacheService.read(any<String>())).called(1);
        verify(() => mockApiService.fetchUserName(any<int>())).called(1);
        verify(() => mockCacheService.write(any<String>(), any<String>()))
            .called(1);
        expect(res, username);
      });
    });

    group("checkIdOrThrow - ", () {
      test("wrong", () {
        expect(() => mockingExamples.checkIdOrThrow(0),
            throwsA(isA<ArgumentError>()));
      });

      test("right", () {
        expect(mockingExamples.checkIdOrThrow(2), 'ok:2');
      });
    });

    group("getUserAgeOrThrow - ", () {
      final int id = 12;
      test("wrong", () async {
        when(() => mockApiService.fetchUserAge(id)).thenAnswer((_) async => -1);
        await expectLater(
          mockingExamples.getUserAgeOrThrow(id),
          throwsA(isA<StateError>()),
        );
      });

      test("right", () async {
        final int age = 24;
        when(() => mockApiService.fetchUserAge(id))
            .thenAnswer((_) async => age);
        final res = await mockingExamples.getUserAgeOrThrow(id);
        expect(res, age);
      });
    });

    test("saveAndLog", () async {
      when(() => mockCacheService.write(any<String>(), any<String>()))
          .thenAnswer((_) async {});
      await mockingExamples.saveAndLog("key", "value");
      verify(() => mockCacheService.write(any<String>(), any<String>()))
          .called(1);
    });

    group("uploadWithRetries", () {
      test("success", () async {
        final String key = "key";
        final List<int> bytes = [1, 2, 3, 4, 5];
        // uploadData returns Future<void>, so we use thenAnswer with async throw
        when(() => mockApiService.uploadData(key, bytes))
            .thenAnswer((_) async => {});
        await mockingExamples.uploadWithRetry(key, bytes);
        verify(() => mockLogger.info(any())).called(1);
        verify(() => mockApiService.uploadData(key, bytes)).called(1);
      });
      test("failure", () async {
        final String key = "key";
        final List<int> bytes = [1, 2, 3, 4, 5];
        // uploadData returns Future<void>, so we use thenAnswer with async throw
        when(() => mockApiService.uploadData(key, bytes))
            .thenAnswer((_) async => throw Exception("something went wrong"));
        await expectLater(mockingExamples.uploadWithRetry(key, bytes),
            throwsA(isA<Exception>()));
        verify(() => mockLogger.error(any(), any(), any())).called(3);
        verify(() => mockApiService.uploadData(key, bytes)).called(3);
      });
    });

    group("sendPayload", () {
      test("success", () async {
        when(
          () => mockCallbackService.sendWithCallback(any(), any()),
        ).thenAnswer((invocation) async {
          final callback = invocation.positionalArguments[1] as Function(bool);
          callback(true);
          return;
        });
        final res = await mockingExamples.sendPayload("abc");
        expect(res, isTrue);
      });

      test("failure", () async {
        when(
          () => mockCallbackService.sendWithCallback(any(), any()),
        ).thenAnswer((invocation) async {
          final callback = invocation.positionalArguments[1] as Function(bool);
          callback(false);
          return;
        });
        final res = await mockingExamples.sendPayload("abc");
        expect(res, isFalse);
      });
    });

    group("formatUser - ", () {
      test("correct", () {
        expect(mockingExamples.formatUser(1, name: "name", title: "title"),
            'titlename#1');
      });
      test("no title", () {
        expect(mockingExamples.formatUser(1, name: "name"), 'name#1');
      });
    });

    test("profileSummary", () async {
      when(() => mockApiService.fetchUserName(1))
          .thenAnswer((_) async => "name");
      when(() => mockApiService.fetchUserAge(1)).thenAnswer((_) async => 12);
      final res = await mockingExamples.profileSummary(1);
      expect(res, 'name is 12');
    });

    test("fireAndForget", () async {
      when(() => mockCacheService.write(any(), any())).thenAnswer((_) async {});
      mockingExamples.fireAndForgetUpdate("", "");
      await untilCalled(() => mockCacheService.write(any(), any()));
      verify(() => mockCacheService.write(any(), any())).called(1);
      verify(() => mockLogger.info(any())).called(1);
    });

    test("delayedVoid", () async {
      await expectLater(mockingExamples.delayedVoid(100), completes);
    });

    test("delayedTransform", () async {
      Stream<int> stream = Stream.fromIterable([1, 2, 3, 4]);
      await expectLater(
          mockingExamples.delayedTransform(stream, Duration(milliseconds: 10)),
          emitsInOrder([2, 3, 4, 5]));
    });
  });
}
