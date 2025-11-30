import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cleanarchexample/widget_testing_practice/auth/login_bloc.dart';
import 'package:cleanarchexample/widget_testing_practice/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class FakeLoginState extends Fake implements LoginState {}

class FakeLoginEvent extends Fake implements LoginEvent {}

// Test keys as constants
class TestKeys {
  static const emailField = Key('emailField');
  static const passwordField = Key('passwordField');
  static const loginButton = Key('loginButton');
  static const homeScreen = Key('homeScreen');
  static const snackbarErrorText = Key("errorText");
}

// Helper extension for common test operations
extension LoginScreenTestHelpers on WidgetTester {
  Finder get emailField => find.byKey(TestKeys.emailField);
  Finder get passwordField => find.byKey(TestKeys.passwordField);
  Finder get loginButton => find.byKey(TestKeys.loginButton);

  ElevatedButton getButton() => widget<ElevatedButton>(loginButton);

  Future<void> enterEmail(String email) async {
    await enterText(emailField, email);
    await pump();
  }

  Future<void> enterPassword(String password) async {
    await enterText(passwordField, password);
    await pump();
  }

  Future<void> fillValidForm() async {
    await enterEmail('test@example.com');
    await enterPassword('password123');
  }
}

// Helper function to create test widget
Widget createTestWidget({
  required MockAuthRepository auth,
  LoginBloc? bloc,
}) {
  return MaterialApp(
    routes: {'/home': (ctx) => const SizedBox(key: TestKeys.homeScreen)},
    home: bloc != null
        ? BlocProvider<LoginBloc>.value(
            value: bloc,
            child: const LoginScreen(),
          )
        : BlocProvider<LoginBloc>(
            create: (_) => LoginBloc(auth: auth),
            child: const LoginScreen(),
          ),
  );
}

void main() {
  late final MockAuthRepository mockAuth;

  setUp(() {
    mockAuth = MockAuthRepository();
  });

  setUpAll(() {
    registerFallbackValue(FakeLoginState());
    registerFallbackValue(FakeLoginEvent());
  });
  group("Login Screen Tests - ", () {
    testWidgets('Initial UI', (tester) async {
      await tester.pumpWidget(createTestWidget(auth: mockAuth));

      expect(tester.emailField, findsOneWidget);
      expect(tester.passwordField, findsOneWidget);
      expect(tester.loginButton, findsOneWidget);

      expect(tester.getButton().onPressed, isNull,
          reason: "Should be disabled initially if form is empty");
    });

    testWidgets('Button is disabled initially', (tester) async {
      await tester.pumpWidget(createTestWidget(auth: mockAuth));

      expect(tester.loginButton, findsOneWidget);
      expect(tester.getButton().onPressed, isNull,
          reason: 'Button should be disabled when form is invalid');
    });

    testWidgets('Button becomes enabled when form is valid', (tester) async {
      await tester.pumpWidget(createTestWidget(auth: mockAuth));

      // Initially disabled
      expect(tester.getButton().onPressed, isNull,
          reason: 'Button should be disabled initially');

      // Enter valid email
      await tester.enterEmail('test@example.com');

      // Still disabled (password not valid yet)
      expect(tester.getButton().onPressed, isNull,
          reason: 'Button should be disabled when only email is valid');

      // Enter valid password (>= 6 characters)
      await tester.enterPassword('password123');

      // Now enabled
      expect(tester.getButton().onPressed, isNotNull,
          reason: 'Button should be enabled when form is valid');
    });

    testWidgets('Button is disabled during loading', (tester) async {
      final bloc = LoginBloc(auth: mockAuth);
      await tester.pumpWidget(createTestWidget(auth: mockAuth, bloc: bloc));

      // Make form valid first
      await tester.fillValidForm();

      // Button should be enabled
      expect(tester.getButton().onPressed, isNotNull);

      Completer<String> completer = Completer<String>();
      // Setup mock to delay response
      when(() => mockAuth.login(any(), any()))
          .thenAnswer((_) => completer.future);

      // Trigger login
      await tester.tap(tester.loginButton);
      await tester.pump(); // Start loading

      // Button should be disabled during loading
      expect(tester.getButton().onPressed, isNull,
          reason: 'Button should be disabled during loading');

      completer.complete("uid");
      await tester.pumpAndSettle();
    });

    testWidgets('successful login takes to homescreen', (tester) async {
      final bloc = LoginBloc(auth: mockAuth);
      await tester.pumpWidget(createTestWidget(auth: mockAuth, bloc: bloc));

      // Make form valid first
      await tester.fillValidForm();

      // Button should be enabled
      expect(tester.getButton().onPressed, isNotNull);

      // Setup mock to delay response
      when(() => mockAuth.login(any(), any())).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return 'user123';
      });

      // Trigger login
      await tester.tap(tester.loginButton);
      await tester.pumpAndSettle(); // Start loading

      expect(find.byKey(TestKeys.homeScreen), findsOneWidget);
    });

    testWidgets('failed login shows snackbar', (tester) async {
      final bloc = LoginBloc(auth: mockAuth);
      await tester.pumpWidget(createTestWidget(auth: mockAuth, bloc: bloc));

      // Make form valid first
      await tester.fillValidForm();

      // Button should be enabled
      expect(tester.getButton().onPressed, isNotNull);

      // Setup mock to delay response
      when(() => mockAuth.login(any(), any())).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        throw Exception("bad creds bro");
      });

      // Trigger login
      await tester.tap(tester.loginButton);
      await tester.pumpAndSettle(); // Start loading

      expect(find.byType(SnackBar), findsOneWidget);
      final snackbarTextFinder = find.byKey(TestKeys.snackbarErrorText);
      expect(snackbarTextFinder, findsOneWidget);

      Text snackbarErrorText = tester.widget<Text>(snackbarTextFinder);
      expect(snackbarErrorText.data, contains("bad creds"));
    });
  });
}
