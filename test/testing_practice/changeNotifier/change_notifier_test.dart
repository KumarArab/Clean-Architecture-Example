import 'package:cleanarchexample/unit_testing_practice/changeNotifier/change_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepo extends Mock implements UserRepository {}

void main() {
  late final MockUserRepo mockUserRepo;
  late final UserViewModel vm;

  setUp(() {
    mockUserRepo = MockUserRepo();
    vm = UserViewModel(mockUserRepo);
  });
  group("loadUser", () {
    test('inital state', () {
      expect(vm.state.loading, isFalse);
      expect(vm.state.error, null);
      expect(vm.state.age, null);
      expect(vm.state.name, null);
    });

    test('success flow', () async {
      final String name = "Naman";
      final int age = 12;

      when(() => mockUserRepo.fetchUserName()).thenAnswer((_) async => name);
      when(() => mockUserRepo.fetchUserAge()).thenAnswer((_) async => age);
      final states = <UserState>[];

      states.add(vm.state);
      vm.addListener(() => states.add(vm.state));
      await vm.loadUser();
      expect(states[1].loading, isTrue);
      expect(states[2].loading, isFalse);
      expect(states[2].error, null);
      expect(states[2].age, age);
      expect(states[2].name, name);
    });

    test('error flow', () async {
      final String name = "Naman";
      final int age = 12;

      when(() => mockUserRepo.fetchUserName())
          .thenThrow(Exception("failed to fetch name"));
      when(() => mockUserRepo.fetchUserAge()).thenAnswer((_) async => age);
      final states = <UserState>[];

      states.add(vm.state);
      vm.addListener(() => states.add(vm.state));
      await vm.loadUser();
      expect(states[1].loading, isTrue);
      expect(states[2].loading, isFalse);
      expect(states[2].error, contains("failed to fetch name"));
      expect(states[2].age, null);
      expect(states[2].name, null);

      verify(() => mockUserRepo.fetchUserName()).called(1);
      verifyNever(() => mockUserRepo.fetchUserAge());
    });

    test('rest flow', () async {
      final String name = "Naman";
      final int age = 12;
      final states = <UserState>[];

      states.add(vm.state);
      vm.addListener(() => states.add(vm.state));
      vm.state = vm.state.copyWith(name: name, age: age);

      vm.reset();

      expect(states[1].loading, isFalse);
      expect(states[1].error, null);
      expect(states[1].age, null);
      expect(states[1].name, null);
    });
  });
}
