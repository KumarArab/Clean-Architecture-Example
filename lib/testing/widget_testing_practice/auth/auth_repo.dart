import 'package:cleanarchexample/testing/widget_testing_practice/auth/login_bloc.dart';

class AuthRepo implements AuthRepository {
  @override
  Future<String> login(String email, String password) {
    return Future.value("");
  }
}
