import 'package:cleanarchexample/auth/data/datasources/data_source.dart';
import 'package:cleanarchexample/auth/data/models/user_model.dart';
import 'package:cleanarchexample/core/exceptions/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDataSource implements IDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseDataSource({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  UserModel getCurrentUser() {
    if (_firebaseAuth.currentUser == null) {
      throw AuthException(message: "No Logged in user found");
    }
    return UserModel.fromFirebaseUser(_firebaseAuth.currentUser!);
  }

  @override
  Future<UserModel> signup(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw AuthException(message: "Failed to signup user, please try again");
      }
      return UserModel.fromFirebaseUser(credential.user!);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (credential.user == null) {
        throw AuthException(message: "Failed to signup user, please try again");
      }
      return UserModel.fromFirebaseUser(credential.user!);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      throw AuthException(
          message: "Failed to Logout, please try again after sometime");
    }
  }
}
