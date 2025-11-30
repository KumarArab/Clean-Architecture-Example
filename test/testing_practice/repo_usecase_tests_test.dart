import 'package:cleanarchexample/unit_testing_practice/repo_usecase_tests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiDataSource extends Mock implements ApiDataSource {}

class MockLocalCache extends Mock implements LocalCache {}

class MockLogger extends Mock implements Logger {}

void main() {
  late final MockApiDataSource mockApiDataSource;
  late final MockLocalCache mockLocalCache;
  late final MockLogger mockLogger;
  late final UserRepository userRepository;

  setUp(() {
    mockApiDataSource = MockApiDataSource();
    mockLocalCache = MockLocalCache();
    mockLogger = MockLogger();
    userRepository = UserRepository(
      api: mockApiDataSource,
      cache: mockLocalCache,
      logger: mockLogger,
    );
  });
  group('repo usecase tests ...', () {
    group("getUser - ", () {
      final int id = 1;

      final User user = User("madmaen", 12);
      test("cache hit", () async {
        when(() => mockLocalCache.read(any())).thenReturn(user.toJson());

        final res = await userRepository.getUser(id);

        expect(res, user);

        // Verify cache was read
        verify(() => mockLocalCache.read("user:$id")).called(1);
        // Verify API was NOT called (cache hit)
        verifyNever(() => mockApiDataSource.getUserJson(any()));
      });

      test("cache miss", () async {
        when(() => mockApiDataSource.getUserJson(any()))
            .thenAnswer((_) async => user.toJson());
        when(() => mockLocalCache.write(any(), any())).thenAnswer((_) async {});
        when(() => mockLocalCache.read(any())).thenReturn(null);
        final res = await userRepository.getUser(id);

        expect(res, user);

        // Verify cache was read
        verify(() => mockLocalCache.read("user:$id")).called(1);
        // Verify API was NOT called (cache hit)
        verify(() => mockApiDataSource.getUserJson(any())).called(1);
        verify(() => mockLocalCache.write("user:$id", user.toJson())).called(1);
      });
    });

    group("getUserSafely", () {
      final int id = 1;
      final User user = User("madmaen", 12);
      test("happy case", () async {
        when(
          () => mockApiDataSource.getUserJson(any()),
        ).thenAnswer((_) async => user.toJson());

        final res = await userRepository.getUserSafely(id);
        expect(res, user);
        verify(() => mockApiDataSource.getUserJson(any())).called(1);
        verifyNever(() => mockLogger.warn(any()));
      });

      test("sad case", () async {
        when(
          () => mockApiDataSource.getUserJson(any()),
        ).thenAnswer((_) async => throw FormatException());

        expect(await userRepository.getUserSafely(id), null);
        verify(() => mockApiDataSource.getUserJson(any())).called(1);
        verify(() => mockLogger.warn(any())).called(1);
      });
    });

    group("getUserWithRetry", () {
      final int id = 1;
      final User user = User("madmaen", 12);
      test("happy case", () async {
        when(
          () => mockApiDataSource.getUserJson(any()),
        ).thenAnswer((_) async => user.toJson());

        final res = await userRepository.getUserWithRetry(id);
        expect(res, user);

        verifyInOrder([
          () => mockApiDataSource.getUserJson(id),
        ]);
      });

      test("sad case", () async {
        when(
          () => mockApiDataSource.getUserJson(any()),
        ).thenAnswer((_) async => throw FormatException());

        await expectLater(userRepository.getUserWithRetry(id),
            throwsA(isA<FormatException>()));

        verifyInOrder([
          () => mockApiDataSource.getUserJson(id),
          () => mockLogger.warn(any()),
          () => mockApiDataSource.getUserJson(id),
          () => mockLogger.warn(any()),
          () => mockApiDataSource.getUserJson(id),
          () => mockLogger.warn(any()),
        ]);
      });
    });

    group("getUserWithTtl - ", () {
      final int id = 1;
      final User user = User("madmaen", 12);
      final DateTime ts = DateTime.now().add(Duration(seconds: 10));
      test("cache hit", () async {
        when(() => mockLocalCache.read(any())).thenReturn(user.toJson());
        when(() => mockLocalCache.readTimestamp(any()))
            .thenAnswer((_) async => ts);

        final res =
            await userRepository.getUserWithTTL(id, Duration(seconds: 20));
        expect(res, user);
      });
    });
  });
}
