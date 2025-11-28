import 'package:cleanarchexample/core/entities/user.dart';
import 'package:flutter/material.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess({required this.user});
}

final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure({required this.message});
}

final class AuthSignOutSuccess extends AuthState {}

final class AuthSignOutFailure extends AuthState {
  final String message;
  const AuthSignOutFailure({required this.message});
}
