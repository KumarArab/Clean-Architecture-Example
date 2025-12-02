import 'package:bloc/bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit([int initial = 0]) : super(initial);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  Future<void> incrementAsync() async {
    await Future.delayed(Duration(milliseconds: 5));
    emit(state + 1);
  }
}
