import 'package:cleanarchexample/widget_testing_practice/greeting/future_repo.dart';
import 'package:flutter/material.dart';

class GreetingWidget extends StatelessWidget {
  final FutureRepository repo;

  const GreetingWidget({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: repo.fetchGreeting(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              key: Key('loading'), child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              key: const Key('error'),
              child: Text('Error: ${snapshot.error}',
                  key: const Key('errorText')));
        } else if (snapshot.hasData) {
          return Center(
              key: const Key('data'),
              child: Text(snapshot.data!, key: const Key('dataText')));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
