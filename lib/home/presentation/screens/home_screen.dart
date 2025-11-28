import 'package:cleanarchexample/auth/presentation/bloc/auth_bloc.dart';
import 'package:cleanarchexample/auth/presentation/bloc/auth_event.dart';
import 'package:cleanarchexample/auth/presentation/bloc/auth_state.dart';
import 'package:cleanarchexample/auth/presentation/screens/login_screen.dart';
import 'package:cleanarchexample/core/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSignOutFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is AuthSignOutSuccess) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (_) => false,
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return CircularProgressIndicator.adaptive();
              }
              return IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthSignOutEvent());
                  },
                  icon: Icon(Icons.logout_rounded));
            },
          )
        ],
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Transform.translate(
              offset: Offset(0, 50),
              child: Image.network(
                Assets.kitty,
                width: 300,
              ),
            ),
            Text(
              "Okarei Home",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            Spacer(flex: 4)
          ],
        ),
      ),
    );
  }
}
