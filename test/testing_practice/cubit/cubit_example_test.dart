import 'package:bloc_test/bloc_test.dart';
import 'package:cleanarchexample/unit_testing_practice/cubit/cubit_example.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CounterCubit counterCubit;

  setUp(() {
    counterCubit = CounterCubit(0);
  });

  tearDown(() {
    counterCubit.close();
  });

  group("Counter Cubit - ", () {
    test('increment', () {
      counterCubit.increment();

      expect(counterCubit.state, 1);
    });

    test('decrement', () {
      counterCubit.decrement();

      expect(counterCubit.state, -1);
    });

    test('incrementAsync', () async {
      await counterCubit.incrementAsync();
      expect(counterCubit.state, 1);
    });
  });

  group("Counter Cubit using blocTest - ", () {
    blocTest<CounterCubit, int>(
      "increment",
      build: () => CounterCubit(0),
      act: (cubit) => cubit.increment(),
      expect: () => [1],
    );

    blocTest<CounterCubit, int>(
      "decrement",
      build: () => CounterCubit(0),
      act: (cubit) => cubit.decrement(),
      expect: () => [-1],
    );

    blocTest<CounterCubit, int>(
      "incrementAsync",
      build: () => CounterCubit(0),
      act: (cubit) => cubit.incrementAsync(),
      wait: Duration(milliseconds: 10),
      expect: () => [1],
    );
  });
}
