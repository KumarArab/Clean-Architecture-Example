import 'package:cleanarchexample/core/entities/user.dart';
import 'package:flutter/material.dart';

@immutable
sealed class AppUserState {
  const AppUserState();
}

final class AppUserInitial extends AppUserState {}

final class AppUserSuccess extends AppUserState {
  final User user;
  const AppUserSuccess({required this.user});
}

final class AuppUserFailure extends AppUserState {}
