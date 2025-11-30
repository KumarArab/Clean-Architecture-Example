import 'package:bloc_test/bloc_test.dart';
import 'package:cleanarchexample/unit_testing_practice/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  MockAuthRepository? mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  tearDown(() {
    mockAuthRepository = null;
  });

  blocTest(
    "on Login requested",
    build: () => AuthBloc(mockAuthRepository!),
    act: (bloc) => bloc.add(LoginRequested("", "")),
    setUp: () {
      when(() => mockAuthRepository!.login(any(), any()))
          .thenAnswer((_) async => "id");
    },
    expect: () => [AuthLoading(), AuthAuthenticated("id")],
  );

  blocTest(
    "on Logout requested",
    build: () => AuthBloc(mockAuthRepository!),
    act: (bloc) => bloc.add(LogoutRequested()),
    setUp: () {
      when(() => mockAuthRepository!.logout()).thenAnswer((_) async {});
    },
    expect: () => [AuthLoading(), AuthInitial()],
  );
}
