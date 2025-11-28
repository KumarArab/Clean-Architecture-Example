import 'package:cleanarchexample/auth/presentation/bloc/auth_bloc.dart';
import 'package:cleanarchexample/auth/presentation/bloc/auth_event.dart';
import 'package:cleanarchexample/auth/presentation/bloc/auth_state.dart';
import 'package:cleanarchexample/auth/presentation/screens/login_screen.dart';
import 'package:cleanarchexample/auth/presentation/widgets/primary_button.dart';
import 'package:cleanarchexample/core/constants/assets.dart';
import 'package:cleanarchexample/core/theme/app_colors.dart';
import 'package:cleanarchexample/home/presentation/screens/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cleanarchexample/auth/presentation/widgets/input_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _signupFormkey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AuthSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
            (_) => false,
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _signupFormkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(0, 30),
                    child: Image.network(
                      Assets.kitty,
                      width: 200,
                    ),
                  ),
                  Text(
                    'Signup',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 20),
                  InputField(
                    label: 'Name',
                    hintText: 'Enter your name',
                    controller: _nameController,
                  ),
                  SizedBox(height: 20),
                  InputField(
                    label: 'Email',
                    hintText: 'Enter your email',
                    controller: _emailController,
                  ),
                  SizedBox(height: 20),
                  InputField(
                    label: 'Password',
                    hintText: 'Enter your password',
                    obscureText: true,
                    controller: _passwordController,
                  ),
                  SizedBox(height: 32),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return PrimaryButton(
                        label: state is AuthLoading ? ". . . ." : "Login",
                        onPressed: () {
                          if (_signupFormkey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  AuthSignupEvent(
                                    name: _nameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  ),
                                );
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  Text.rich(TextSpan(
                      text: "Already have a kitty account! Log in ",
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: "here",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: AppColors.primaryLightColor,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => LoginScreen()),
                                  (_) => false);
                            },
                        )
                      ])),
                  Spacer()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
