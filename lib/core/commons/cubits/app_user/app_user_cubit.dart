import 'package:cleanarchexample/core/commons/cubits/app_user/app_user_state.dart';
import 'package:cleanarchexample/core/entities/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserInitial());
    } else {
      emit(AppUserSuccess(user: user));
    }
  }
}
