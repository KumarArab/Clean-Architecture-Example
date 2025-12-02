part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final String email;
  final bool emailValid;
  final String password;
  final bool passwordValid;
  final bool formValid;
  final LoginStatus status;
  final String? errorMessage;
  final String? userId;

  const LoginState({
    required this.email,
    required this.emailValid,
    required this.password,
    required this.passwordValid,
    required this.formValid,
    required this.status,
    this.errorMessage,
    this.userId,
  });

  factory LoginState.initial() => const LoginState(
        email: '',
        emailValid: false,
        password: '',
        passwordValid: false,
        formValid: false,
        status: LoginStatus.initial,
      );

  LoginState copyWith({
    String? email,
    bool? emailValid,
    String? password,
    bool? passwordValid,
    bool? formValid,
    LoginStatus? status,
    String? errorMessage,
    String? userId,
  }) {
    return LoginState(
      email: email ?? this.email,
      emailValid: emailValid ?? this.emailValid,
      password: password ?? this.password,
      passwordValid: passwordValid ?? this.passwordValid,
      formValid: formValid ?? this.formValid,
      status: status ?? this.status,
      errorMessage: errorMessage,
      userId: userId ?? this.userId,
    );
  }
}
