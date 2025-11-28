import 'package:cleanarchexample/auth/data/datasources/data_source.dart';
import 'package:cleanarchexample/auth/data/datasources/firebase_data_source.dart';
import 'package:cleanarchexample/auth/data/repos/auth_repo_impl.dart';
import 'package:cleanarchexample/auth/domain/repos/auth_repo.dart';
import 'package:cleanarchexample/auth/domain/usecases/is_user_logged_in_usecase.dart';
import 'package:cleanarchexample/auth/domain/usecases/login_usecase.dart';
import 'package:cleanarchexample/auth/domain/usecases/sign_out_usecase.dart';
import 'package:cleanarchexample/auth/domain/usecases/signup_usecase.dart';
import 'package:cleanarchexample/auth/presentation/bloc/auth_bloc.dart';
import 'package:cleanarchexample/core/commons/cubits/app_user/app_user_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

part 'dependencies_main.dart';
