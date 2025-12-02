class SimpleAsync {
  Future<String> fetchValue() async {
    // imagine a network call
    await Future.delayed(Duration(milliseconds: 1));
    return 'hello';
  }

  Future<String> fetchThatFails() async {
    await Future.delayed(Duration(milliseconds: 1));
    throw FormatException('bad format');
  }

  Future<int> retryingFetch(Future<int> Function() remote,
      {int retries = 3}) async {
    var attempts = 0;
    while (true) {
      try {
        attempts++;
        return await remote();
      } catch (e) {
        if (attempts >= retries) rethrow;
      }
    }
  }

  Future<int> fetchUserAge() async {
    await Future.delayed(const Duration(milliseconds: 5));
    return 25;
  }

  Future<String> fetchUserName() async {
    await Future.delayed(const Duration(milliseconds: 5));
    return "Alice";
  }

  Future<String> fetchUserNameWithError() async {
    await Future.delayed(const Duration(milliseconds: 5));
    throw FormatException("Invalid response");
  }

  Future<bool> isAdult() async {
    final age = await fetchUserAge();
    return age >= 18;
  }

  Future<String> fetchFullProfile() async {
    final name = await fetchUserName();
    final age = await fetchUserAge();
    return "$name is $age years old";
  }

  Future<T> retry<T>(
    Future<T> Function() action, {
    int maxRetries = 3,
  }) async {
    int attempt = 0;
    while (true) {
      try {
        return await action();
      } catch (_) {
        attempt++;
        if (attempt >= maxRetries) rethrow;
      }
    }
  }
}
