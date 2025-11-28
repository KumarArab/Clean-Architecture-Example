import 'package:cleanarchexample/auth/data/models/user_model.dart';

abstract interface class IDataSource {
  UserModel getCurrentUser();
  Future<bool> signOut();
  Future<UserModel> signup(
      {required String name, required String email, required String password});
  Future<UserModel> login({required String email, required String password});
}
