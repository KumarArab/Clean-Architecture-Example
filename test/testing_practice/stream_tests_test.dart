import 'dart:async';

import 'package:cleanarchexample/unit_testing_practice/stream_tests.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  late StreamExamples streamExamples;

  setUp(() async {
    streamExamples = StreamExamples();
  });
  group("Stream tests", () async {
    test('count to', () async {
      final res = streamExamples.countTo(3);
      await expectLater(res, emitsInOrder([1, 2, 3, emitsDone]));
    });

    test('greetings', () async {
      final res = streamExamples.greetings();
      await expectLater(res, emitsInOrder(['hello', 'world', emitsDone]));
    });

    test('faultyStream', () async {
      final res = streamExamples.faultyStream();
      await expectLater(
          res,
          emitsInOrder(
            [1, 2, emitsError(isA<Exception>())],
          ));
    });

    test('delayedStream', () async {
      final List<String> items = ['a', 'b', 'c', 'd'];
      final res =
          streamExamples.delayedStream(items, Duration(milliseconds: 10));
      await expectLater(res, emitsInOrder(items));
    });

    test('broadcastStream', () async {
      final res = expectLater(
          streamExamples.broadcastStream,
          emitsInOrder(
            [1, 2, 3, emitsError(isA<Exception>()), 5, emitsDone],
          ));
      streamExamples.addToBroadcast(1);
      streamExamples.addToBroadcast(2);
      streamExamples.addToBroadcast(3);
      streamExamples.addErrorToBroadcast(Exception());
      streamExamples.addToBroadcast(5);
      await streamExamples.closeBroadcast();
      await res;
    });
    test('singleStreamController', () async {
      final res = streamExamples.createSingleStreamController();
      await expectLater(
          res,
          emitsInOrder(
            [1, 2, 3, emitsError(isA<Exception>()), 5, emitsDone],
          ));
      streamExamples.addToSingle(1);
      streamExamples.addToSingle(2);
      streamExamples.addToSingle(3);
      streamExamples.addErrorToSingle(Exception());
      streamExamples.addToSingle(5);
      streamExamples.closeSingle();
    });

    test('periodicCount', () async {
      final res = streamExamples.periodicCount(Duration(milliseconds: 100), 5);
      await expectLater(res, emitsInOrder([1, 2, 3, 4, 5, emitsDone]));
    });
    test('fromIterable', () async {
      final List<String> items = ['a', 'b', 'c', 'd'];
      final res = streamExamples.fromIterable(items);
      await expectLater(res, emitsInOrder(['a', 'b', 'c', 'd']));
    });

    test('mergeTwo', () async {
      final Stream<int> stream1 =
          Stream.periodic(Duration(milliseconds: 100), (val) {
        return val;
      });
      final Stream<int> stream2 =
          Stream.periodic(Duration(milliseconds: 100), (val) {
        return val;
      });
      final res = streamExamples.mergeTwo(stream1, stream2);
      await expectLater(res, emitsInOrder([0, 0]));
    });
  });

  test("uppercase", () async {
    final Stream<String> stream = Stream.value("Ravi");
    final res = streamExamples.uppercase(stream);
    await expectLater(res, emitsInOrder(["RAVI"]));
  });

  test("filtered", () async {
    final Stream<int> stream = Stream.fromIterable([1, 2, 3, 4, 5, 6]);

    bool test(int val) {
      return val % 2 != 0;
    }

    final res = streamExamples.filtered(stream, test);
    await expectLater(res, emitsInOrder([1, 3, 5]));
  });

  test("transformWithIncrement", () async {
    final Stream<int> stream = Stream.fromIterable([1, 2, 3, 4, 5, 6]);

    final res = streamExamples.transformWithIncrement(stream, 2);
    await expectLater(res, emitsInOrder([3, 4, 5, 6, 7, 8]));
  });

  test("withFallback", () async {
    final StreamController controller = StreamController();

    final res = streamExamples.withFallback(controller.stream, 99);
    await expectLater(
        res, emitsInOrder([1, 2, emitsError(isA<Exception>()), emitsDone]));
    controller.add(1);
    controller.add(2);
    controller.add(Exception());
    controller.close();
  });

  test("mapFutureResult", () async {
    Future<int> futureVal() async {
      return Future.value(100);
    }

    Stream<Future<int>> stream = Stream.value(futureVal());

    final res = streamExamples.mapFutureResults(stream);
    await expectLater(res, emitsInOrder([100]));
  });
}
