import 'package:flutter/foundation.dart';

// Simulated repository interface
abstract class UserRepository {
  Future<String> fetchUserName();
  Future<int> fetchUserAge();
}

/// State model
class UserState {
  final bool loading;
  final String? name;
  final int? age;
  final String? error;

  const UserState({
    required this.loading,
    this.name,
    this.age,
    this.error,
  });

  factory UserState.initial() => const UserState(loading: false);
  @override
  String toString() =>
      "Name: $name, Loading: $loading, Age: $age, Error: $error";

  UserState copyWith({
    bool? loading,
    String? name,
    int? age,
    String? error,
  }) {
    return UserState(
      loading: loading ?? this.loading,
      name: name ?? this.name,
      age: age ?? this.age,
      error: error,
    );
  }
}

/// ViewModel (SUT)
class UserViewModel extends ChangeNotifier {
  final UserRepository repo;
  UserState state = UserState.initial();

  UserViewModel(this.repo);

  Future<void> loadUser() async {
    state = state.copyWith(loading: true, error: null);
    notifyListeners();

    try {
      final name = await repo.fetchUserName();
      final age = await repo.fetchUserAge();
      state = state.copyWith(loading: false, name: name, age: age);
      notifyListeners();
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      notifyListeners();
    }
  }

  void reset() {
    state = UserState.initial();
    notifyListeners();
  }
}
