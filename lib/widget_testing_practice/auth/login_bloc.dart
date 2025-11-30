import 'package:bloc/bloc.dart';
import 'dart:async';

part 'login_event.dart';
part 'login_state.dart';

/// Simulated login repository (in real app inject this)
abstract class AuthRepository {
  Future<String> login(String email, String password);
}

/// Bloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository auth;

  LoginBloc({required this.auth}) : super(LoginState.initial()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onEmailChanged(EmailChanged e, Emitter<LoginState> emit) {
    final email = e.email.trim();
    final emailValid = _validateEmail(email);
    emit(state.copyWith(
        email: email,
        emailValid: emailValid,
        formValid: emailValid && state.passwordValid));
  }

  void _onPasswordChanged(PasswordChanged e, Emitter<LoginState> emit) {
    final password = e.password;
    final passwordValid = password.length >= 6;
    emit(state.copyWith(
        password: password,
        passwordValid: passwordValid,
        formValid: passwordValid && state.emailValid));
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted e, Emitter<LoginState> emit) async {
    if (!state.formValid) return; // ignore submissions when invalid

    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));
    try {
      final userId = await auth.login(state.email, state.password);
      emit(state.copyWith(status: LoginStatus.success, userId: userId));
    } catch (err) {
      emit(state.copyWith(
          status: LoginStatus.failure, errorMessage: err.toString()));
    }
  }

  bool _validateEmail(String email) {
    return RegExp(r"^[\w\.\-]+@[\w\.\-]+\.\w+$").hasMatch(email);
  }
}
