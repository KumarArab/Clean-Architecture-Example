import 'package:cleanarchexample/clean_architecture/core/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserModel extends User {
  UserModel({
    required super.name,
    required super.email,
    required super.uid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String?,
      email: json['email'] as String?,
      uid: json['uid'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
    };
  }

  factory UserModel.fromFirebaseUser(firebase_auth.User user) {
    return UserModel(
      name: user.displayName,
      email: user.email,
      uid: user.uid,
    );
  }

  /// Creates a copy of this UserModel with the given fields replaced
  UserModel copyWith({
    String? name,
    String? email,
    String? uid,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      uid: uid ?? this.uid,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.name == name &&
        other.email == email &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return Object.hash(name, email, uid);
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, uid: $uid)';
  }
}
