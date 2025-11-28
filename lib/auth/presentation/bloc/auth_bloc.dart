import 'package:cleanarchexample/auth/domain/usecases/is_user_logged_in_usecase.dart';
import 'package:cleanarchexample/auth/domain/usecases/login_usecase.dart';
import 'package:cleanarchexample/auth/domain/usecases/sign_out_usecase.dart';
import 'package:cleanarchexample/auth/domain/usecases/signup_usecase.dart';
import 'package:cleanarchexample/auth/presentation/bloc/auth_event.dart';
import 'package:cleanarchexample/auth/presentation/bloc/auth_state.dart';
import 'package:cleanarchexample/core/commons/cubits/app_user/app_user_cubit.dart';
import 'package:cleanarchexample/core/logger/logger.dart';
import 'package:cleanarchexample/core/usecase/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with Logger {
  final SignupUseCase _signupUseCase;
  final LoginUseCase _loginUseCase;
  final CurrentUserUseCase _currentUserUseCase;
  final SignOutUsecase _signOutUseCase;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required SignupUseCase signupUseCase,
    required LoginUseCase loginUseCase,
    required CurrentUserUseCase currentUserUseCase,
    required AppUserCubit appUserCubit,
    required SignOutUsecase singOutUseCase,
  })  : _signupUseCase = signupUseCase,
        _loginUseCase = loginUseCase,
        _currentUserUseCase = currentUserUseCase,
        _appUserCubit = appUserCubit,
        _signOutUseCase = singOutUseCase,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) => emit(AuthLoading()));
    on<AuthLoginEvent>(_handleAuthLogin);
    on<AuthSignupEvent>(_handleAuthSignup);
    on<AuthIsUserLoggedInEvent>(_handleIsUserLoggedIn);
    on<AuthSignOutEvent>(_handleSignout);
  }

  _handleIsUserLoggedIn(AuthIsUserLoggedInEvent event, Emitter emit) async {
    logInfo("is user logged in called");
    final response = _currentUserUseCase(NoParams());
    response.fold((l) => emit(AuthFailure(message: l.message)), (r) {
      _appUserCubit.updateUser(r);
      emit(AuthSuccess(user: r));
    });
  }

  _handleSignout(AuthSignOutEvent event, Emitter emit) async {
    final response = await _signOutUseCase(NoParams());

    response.fold((l) {
      emit(AuthSignOutFailure(message: l.message));
    }, (r) {
      _appUserCubit.updateUser(null);
      emit(AuthSignOutSuccess());
    });
  }

  _handleAuthSignup(AuthSignupEvent event, Emitter<AuthState> emit) async {
    logInfo("signup called");
    final response = await _signupUseCase(SignupUseCaseParams(
      name: event.name,
      email: event.email,
      password: event.password,
    ));
    response.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) => emit(AuthSuccess(user: r)),
    );
  }

  _handleAuthLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    logInfo("login called");
    final response = await _loginUseCase(LoginUseCaseParams(
      email: event.email,
      password: event.password,
    ));
    response.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) => emit(AuthSuccess(user: r)),
    );
  }
}
