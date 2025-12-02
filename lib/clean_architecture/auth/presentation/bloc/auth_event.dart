import 'package:flutter/material.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

final class AuthSignupEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthSignupEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginEvent({
    required this.email,
    required this.password,
  });
}

final class AuthSignOutEvent extends AuthEvent {}

final class AuthIsUserLoggedInEvent extends AuthEvent {}
