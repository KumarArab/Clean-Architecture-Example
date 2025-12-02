import 'package:cleanarchexample/clean_architecture/auth/presentation/bloc/auth_bloc.dart';
import 'package:cleanarchexample/clean_architecture/auth/presentation/bloc/auth_event.dart';
import 'package:cleanarchexample/clean_architecture/auth/presentation/bloc/auth_state.dart';
import 'package:cleanarchexample/clean_architecture/auth/presentation/screens/login_screen.dart';
import 'package:cleanarchexample/clean_architecture/core/theme/app_colors.dart';
import 'package:cleanarchexample/clean_architecture/home/presentation/bloc/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeFetchEmployeesEvent(firstFetch: true));
    scrollController = ScrollController()..addListener(_paginationListener);
  }

  void _paginationListener() {
    if (scrollController.position.pixels >
        scrollController.position.maxScrollExtent * 0.8) {
      context.read<HomeBloc>().add(HomeFetchEmployeesEvent(firstFetch: false));
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

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
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomePaginationErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is HomeLoadingState && state.firstFetch) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          // Get employees from any state that has them
          final employees = state.employees;
          if (state is HomeErrorState && employees.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.red),
                ),
              ),
            );
          }
          return SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  if (employees.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: employees.length,
                        itemBuilder: (ctx, i) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            tileColor: AppColors.primaryColor,
                            title: Text(employees[i].id?.toString() ?? ""),
                            subtitle: Text(
                              employees[i].title ?? "",
                              maxLines: 1,
                            ),
                            trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.chevron_right_rounded)),
                          ),
                        ),
                      ),
                    ),
                  if (state is HomeLoadingState && !state.firstFetch)
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    )
                ],
              ));
        },
      ),
    );
  }
}
