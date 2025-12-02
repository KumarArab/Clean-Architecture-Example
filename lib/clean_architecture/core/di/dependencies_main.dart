part of 'dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Register FirebaseAuth first since other dependencies depend on it
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  serviceLocator.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);

  // Register AppUserCubit
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );

  // Initialize auth dependencies (which depend on FirebaseAuth)
  _initAuth();

  _initHome();
}

Future<void> _initAuth() async {
  serviceLocator.registerFactory<IDataSource>(
      () => FirebaseDataSource(firebaseAuth: serviceLocator()));

  serviceLocator.registerFactory<IAuthRepository>(
      () => AuthRepository(dataSource: serviceLocator()));

  serviceLocator.registerFactory<SignupUseCase>(
      () => SignupUseCase(authRepository: serviceLocator()));
  serviceLocator.registerFactory<LoginUseCase>(
      () => LoginUseCase(authRepository: serviceLocator()));
  serviceLocator.registerFactory<CurrentUserUseCase>(
      () => CurrentUserUseCase(authRepository: serviceLocator()));
  serviceLocator.registerFactory<SignOutUsecase>(
      () => SignOutUsecase(authRepository: serviceLocator()));

  serviceLocator.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      signupUseCase: serviceLocator(),
      loginUseCase: serviceLocator(),
      currentUserUseCase: serviceLocator(),
      appUserCubit: serviceLocator(),
      singOutUseCase: serviceLocator(),
    ),
  );
}

_initHome() {
  serviceLocator
      .registerLazySingleton<INetworkRepository>(() => NetworkRepository());

  serviceLocator.registerFactory<IHomeRepository>(
      () => HomeRepository(networkRepository: serviceLocator()));

  serviceLocator.registerFactory<FetchEmployeesUsecase>(
      () => FetchEmployeesUsecase(homeRepository: serviceLocator()));
  serviceLocator.registerFactory<SearchEmployeesUsecase>(
      () => SearchEmployeesUsecase(homeRepository: serviceLocator()));

  serviceLocator.registerFactory<HomeBloc>(
      () => HomeBloc(fetchEmployeeUsecase: serviceLocator()));
}
