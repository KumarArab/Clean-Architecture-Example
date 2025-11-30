// lib/testing_practice/mocking_examples.dart

import 'dart:async';

/// ===== Dependencies (interfaces you will mock in tests) =====

abstract class ApiService {
  Future<String> fetchUserName(int userId);
  Future<int> fetchUserAge(int userId);
  Future<void> uploadData(String key, List<int> bytes);
  Stream<String> eventStream(); // stream of events from server
}

abstract class CacheService {
  String? read(String key);
  Future<void> write(String key, String value);
  Future<void> clear();
}

abstract class Logger {
  void info(String message);
  void error(String message, [Object? err, StackTrace? st]);
}

/// A generic callback-style dependency to show capturing arguments
abstract class CallbackService {
  void sendWithCallback(String payload, void Function(bool success) callback);
}

/// ===== Class under test: various methods to test with mocks =====

class MockingExamples {
  final ApiService api;
  final CacheService cache;
  final Logger logger;
  final CallbackService callbackService;

  MockingExamples({
    required this.api,
    required this.cache,
    required this.logger,
    required this.callbackService,
  });

  // -----------------------
  // 1) Simple delegation (async)
  // -----------------------
  /// Fetches username from API and returns it.
  Future<String> getUserName(int id) => api.fetchUserName(id);

  // -----------------------
  // 2) Sync method calling cache then API as fallback
  // -----------------------
  /// Returns cached value if present, otherwise fetches from API,
  /// writes to cache asynchronously, then returns the value.
  Future<String> getCachedOrFetch(int id) async {
    final key = 'user:$id:name';
    final cached = cache.read(key);
    if (cached != null) return cached;

    final name = await api.fetchUserName(id);
    // write but don't wait (simulate fire-and-forget cache update)
    unawaited(cache.write(key, name));
    return name;
  }

  // -----------------------
  // 3) Method that throws synchronously for invalid args
  // -----------------------
  /// Throws immediately if id <= 0
  String checkIdOrThrow(int id) {
    if (id <= 0) throw ArgumentError('id must be > 0');
    return 'ok:$id';
  }

  // -----------------------
  // 4) Async throw (API error)
  // -----------------------
  Future<int> getUserAgeOrThrow(int id) async {
    final age = await api.fetchUserAge(id); // may throw
    if (age < 0) throw StateError('invalid age');
    return age;
  }

  // -----------------------
  // 5) Void-returning method that calls dependencies
  // -----------------------
  /// Saves a string to cache and logs it.
  Future<void> saveAndLog(String key, String value) async {
    await cache.write(key, value);
    logger.info('saved $key');
  }

  // -----------------------
  // 6) Method that uploads and handles api errors with rethrow
  // -----------------------
  Future<void> uploadWithRetry(String key, List<int> bytes,
      {int maxRetries = 3}) async {
    var tries = 0;
    while (true) {
      try {
        tries++;
        await api.uploadData(key, bytes);
        logger.info('uploaded $key in $tries tries');
        return;
      } catch (e, st) {
        logger.error('upload failed', e, st);
        if (tries >= maxRetries) rethrow;
        // simple delay between retries
        await Future.delayed(Duration(milliseconds: 5));
      }
    }
  }

  // -----------------------
  // 7) Stream usage (delegation)
  // -----------------------
  Stream<String> events() => api.eventStream();

  // -----------------------
  // 8) Callback-style interface (convert callback to Future)
  // -----------------------
  Future<bool> sendPayload(String payload) {
    final completer = Completer<bool>();
    callbackService.sendWithCallback(payload, (success) {
      completer.complete(success);
    });
    return completer.future;
  }

  // -----------------------
  // 9) Generic method
  // -----------------------
  T echoGeneric<T>(T value) => value;

  // -----------------------
  // 10) Method with named + positional args
  // -----------------------
  String formatUser(int id, {required String name, String? title}) {
    return '${title ?? ''}$name#$id';
  }

  // -----------------------
  // 11) Method demonstrating dependency chaining
  // -----------------------
  /// Calls api.fetchUserName -> api.fetchUserAge -> returns combined string
  Future<String> profileSummary(int id) async {
    final name = await api.fetchUserName(id);
    final age = await api.fetchUserAge(id);
    return '$name is $age';
  }

  // -----------------------
  // 12) Helper: method that uses unawaited to show fire-and-forget (test capturing)
  // -----------------------
  void fireAndForgetUpdate(String key, String value) {
    // write but do not await; logger should still be called
    cache.write(key, value);
    logger.info('scheduled write for $key');
  }

  // -----------------------
  // 13) Method that returns Future<void> after some delay
  // -----------------------
  Future<void> delayedVoid(int ms) async {
    await Future.delayed(Duration(milliseconds: ms));
  }

  // -----------------------
  // 14) Method that transforms a stream with a delay (for testing stream-mock)
  // -----------------------
  Stream<int> delayedTransform(Stream<int> input, Duration delay) async* {
    await for (final v in input) {
      await Future.delayed(delay);
      yield v + 1;
    }
  }
}

/// Simple utility used above to avoid analyzer warning about unawaited futures.
void unawaited(Future<void> _) {}
