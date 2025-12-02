// lib/testing_practice/hour5_examples.dart

import 'dart:async';

/// =============================
/// DATA MODELS
/// =============================

class User {
  final String name;
  final int age;

  User(this.name, this.age);

  factory User.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('name') || !json.containsKey('age')) {
      throw FormatException("Invalid JSON: missing keys");
    }
    return User(
      json['name'] as String,
      json['age'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "age": age,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          age == other.age;

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}

/// =============================
/// DEPENDENCIES (to be mocked)
/// =============================

abstract class ApiDataSource {
  Future<Map<String, dynamic>> getUserJson(int id);
  Future<Map<String, dynamic>> getProfileJson(int id);
  Future<void> updateUser(int id, Map<String, dynamic> data);
  Stream<Map<String, dynamic>> userStream(int id);
}

abstract class LocalCache {
  Map<String, dynamic>? read(String key);
  Future<void> write(String key, Map<String, dynamic> value);
  Future<DateTime?> readTimestamp(String key);
  Future<void> writeTimestamp(String key, DateTime timestamp);
}

abstract class Logger {
  void info(String message);
  void warn(String message);
  void error(String message, [Object? err]);
}

/// =============================
/// REPOSITORY (SUT)
/// =============================

class UserRepository {
  final ApiDataSource api;
  final LocalCache cache;
  final Logger logger;

  UserRepository({
    required this.api,
    required this.cache,
    required this.logger,
  });

  /// -----------------------------
  /// 1) Cache hit → return cached
  /// 2) Cache miss → fetch from API
  /// -----------------------------
  Future<User> getUser(int id) async {
    final key = "user:$id";

    // check cache
    final cached = cache.read(key);
    if (cached != null) {
      logger.info("cache hit");
      return User.fromJson(cached);
    }

    // fetch from network
    final json = await api.getUserJson(id);
    final user = User.fromJson(json);

    // write to cache
    await cache.write(key, user.toJson());
    logger.info("cache write");

    return user;
  }

  /// -----------------------------
  /// Safe fetch → return null on error
  /// -----------------------------
  Future<User?> getUserSafely(int id) async {
    try {
      final json = await api.getUserJson(id);
      return User.fromJson(json);
    } catch (e) {
      logger.warn("safe fetch failed for id=$id");
      return null;
    }
  }

  /// -----------------------------
  /// Retry API request before failing
  /// -----------------------------
  Future<User> getUserWithRetry(int id, {int retries = 3}) async {
    int attempt = 0;

    while (true) {
      try {
        attempt++;
        final json = await api.getUserJson(id);
        return User.fromJson(json);
      } catch (e) {
        logger.warn("attempt $attempt failed");
        if (attempt >= retries) rethrow;
        await Future.delayed(Duration(milliseconds: 5));
      }
    }
  }

  /// -----------------------------
  /// TTL (time-to-live) cache logic
  /// -----------------------------
  Future<User> getUserWithTTL(int id, Duration ttl) async {
    final key = "user:$id";
    final timestampKey = "user:$id:ts";

    final cached = cache.read(key);
    final ts = await cache.readTimestamp(timestampKey);

    if (cached != null && ts != null) {
      final now = DateTime.now();
      final age = now.difference(ts);
      if (age <= ttl) {
        logger.info("TTL cache hit");
        return User.fromJson(cached);
      }
    }

    final json = await api.getUserJson(id);
    await cache.write(key, json);
    await cache.writeTimestamp(timestampKey, DateTime.now());
    logger.info("TTL cache write");
    return User.fromJson(json);
  }

  /// -----------------------------
  /// Combine two API calls into one result
  /// -----------------------------
  Future<String> buildProfileSummary(int id) async {
    final userJson = await api.getUserJson(id);
    final profileJson = await api.getProfileJson(id);

    final user = User.fromJson(userJson);
    final nickname = profileJson["nickname"] as String? ?? "unknown";

    return "${user.name} (${user.age}) — $nickname";
  }

  /// -----------------------------
  /// Transform Stream from API
  /// -----------------------------
  Stream<User> watchUser(int id) async* {
    await for (final json in api.userStream(id)) {
      try {
        yield User.fromJson(json);
      } catch (e) {
        logger.error("invalid user update", e);
      }
    }
  }

  /// -----------------------------
  /// Update User → propagate errors
  /// -----------------------------
  Future<void> updateUser(int id, User user) async {
    final data = user.toJson();
    await api.updateUser(id, data);
  }
}
