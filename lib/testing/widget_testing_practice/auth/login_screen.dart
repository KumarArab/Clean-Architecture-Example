import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_bloc.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocListener<LoginBloc, LoginState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == LoginStatus.success) {
              Navigator.of(context)
                  .pushReplacementNamed('/home', arguments: state.userId);
            } else if (state.status == LoginStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.errorMessage ?? 'Login failed')));
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextField(
                key: const Key('emailField'),
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (v) =>
                    context.read<LoginBloc>().add(EmailChanged(v)),
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('passwordField'),
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (v) =>
                    context.read<LoginBloc>().add(PasswordChanged(v)),
              ),
              const SizedBox(height: 20),
              BlocBuilder<LoginBloc, LoginState>(
                buildWhen: (p, c) =>
                    p.formValid != c.formValid || p.status != c.status,
                builder: (context, state) {
                  return ElevatedButton(
                    key: const Key('loginButton'),
                    onPressed: state.formValid &&
                            state.status != LoginStatus.loading
                        ? () => context.read<LoginBloc>().add(LoginSubmitted())
                        : null,
                    child: state.status == LoginStatus.loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Login'),
                  );
                },
              ),
              const SizedBox(height: 12),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state.status == LoginStatus.failure) {
                    return Text('Error: ${state.errorMessage}',
                        key: const Key('errorText'),
                        style: const TextStyle(color: Colors.red));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
