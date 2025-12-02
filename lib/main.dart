import 'package:cleanarchexample/clean_architecture/auth/presentation/bloc/auth_bloc.dart';
import 'package:cleanarchexample/clean_architecture/auth/presentation/bloc/auth_event.dart';
import 'package:cleanarchexample/clean_architecture/auth/presentation/screens/login_screen.dart';
import 'package:cleanarchexample/clean_architecture/home/presentation/bloc/bloc/home_bloc.dart';
import 'package:cleanarchexample/clean_architecture/home/presentation/screens/home_screen.dart';
import 'package:cleanarchexample/clean_architecture/core/commons/cubits/app_user/app_user_cubit.dart';
import 'package:cleanarchexample/clean_architecture/core/commons/cubits/app_user/app_user_state.dart';
import 'package:cleanarchexample/clean_architecture/core/di/dependencies.dart';
import 'package:cleanarchexample/clean_architecture/core/navigation/navigation_observer.dart';
import 'package:cleanarchexample/clean_architecture/core/theme/app_theme.dart';
import 'package:cleanarchexample/firebase_options.dart';
// import 'package:cleanarchexample/testing/widget_testing_practice/auth/auth_repo.dart';
// import 'package:cleanarchexample/testing/widget_testing_practice/auth/login_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      // BlocProvider(create: (_) => LoginBloc(auth: AuthRepo())),
      BlocProvider(create: (_) => serviceLocator<HomeBloc>()),
      BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
      BlocProvider(create: (_) => serviceLocator<AuthBloc>())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedInEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      navigatorObservers: [KittyNavigationObserver()],
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserSuccess;
        },
        builder: (ctx, isLoggedIn) {
          return isLoggedIn ? HomeScreen() : LoginScreen();
        },
      ),
      // home: LoginScreen(),
    );
  }
}
