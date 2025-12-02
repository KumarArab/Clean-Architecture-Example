// lib/testing_practice/stream_examples.dart

import 'dart:async';

class StreamExamples {
  StreamExamples();

  // ----------------------------
  // 1) Simple async* generator
  // ----------------------------
  /// Emits integers from 1 to [n] (inclusive).
  Stream<int> countTo(int n) async* {
    for (var i = 1; i <= n; i++) {
      yield i;
    }
  }

  // ----------------------------
  // 2) Simple string generator
  // ----------------------------
  Stream<String> greetings() async* {
    yield 'hello';
    yield 'world';
  }

  // ----------------------------
  // 3) Faulty stream (emits then throws)
  // ----------------------------
  Stream<int> faultyStream() async* {
    yield 1;
    yield 2;
    throw Exception('boom');
  }

  // ----------------------------
  // 4) Delayed emissions (useful for fake_async later)
  // ----------------------------
  Stream<String> delayedStream(List<String> items, Duration delay) async* {
    for (final item in items) {
      await Future.delayed(delay);
      yield item;
    }
  }

  // ----------------------------
  // 5) Broadcast StreamController (many listeners)
  //    - tests can push events using addToBroadcast/addErrorToBroadcast/closeBroadcast
  // ----------------------------
  final StreamController<int> _broadcastController =
      StreamController<int>.broadcast();

  Stream<int> get broadcastStream => _broadcastController.stream;

  void addToBroadcast(int value) => _broadcastController.add(value);

  void addErrorToBroadcast(Object error) =>
      _broadcastController.addError(error);

  Future<void> closeBroadcast() => _broadcastController.close();

  // ----------------------------
  // 6) Single-subscription StreamController (create on demand)
  //    - useful to simulate event sources that only allow one subscription
  // ----------------------------
  StreamController<int>? _singleController;

  /// Creates and returns a single-subscription stream; recreate for new tests
  Stream<int> createSingleStreamController() {
    _singleController?.close();
    _singleController = StreamController<int>();
    return _singleController!.stream;
  }

  void addToSingle(int value) => _singleController?.add(value);

  void addErrorToSingle(Object error) => _singleController?.addError(error);

  Future<void> closeSingle() async {
    await _singleController?.close();
    _singleController = null;
  }

  // ----------------------------
  // 7) Periodic stream using Stream.periodic (use .take to limit)
  // ----------------------------
  Stream<int> periodicCount(Duration period, int count) {
    return Stream<int>.periodic(period, (tick) => tick + 1).take(count);
  }

  // ----------------------------
  // 8) Stream from iterable
  // ----------------------------
  Stream<T> fromIterable<T>(Iterable<T> items) => Stream.fromIterable(items);

  // ----------------------------
  // 9) Merge two streams into a single stream (emits values from both)
  //    - closes when both inputs are done
  // ----------------------------
  Stream<T> mergeTwo<T>(Stream<T> a, Stream<T> b) {
    final controller = StreamController<T>();

    var completed = 0;

    void maybeClose() {
      completed++;
      if (completed >= 2) {
        controller.close();
      }
    }

    a.listen(
      (event) => controller.add(event),
      onError: (err, st) => controller.addError(err, st),
      onDone: maybeClose,
    );

    b.listen(
      (event) => controller.add(event),
      onError: (err, st) => controller.addError(err, st),
      onDone: maybeClose,
    );

    return controller.stream;
  }

  // ----------------------------
  // 10) Transform / map example using transform or map
  // ----------------------------
  Stream<String> uppercase(Stream<String> input) =>
      input.map((s) => s.toUpperCase());

  Stream<int> filtered(Stream<int> input, bool Function(int) test) =>
      input.where(test);

  Stream<int> transformWithIncrement(Stream<int> input, int increment) {
    return input.transform(
      StreamTransformer<int, int>.fromHandlers(
        handleData: (data, sink) => sink.add(data + increment),
        handleError: (err, st, sink) => sink.addError(err, st),
      ),
    );
  }

  // ----------------------------
  // 11) Safe stream wrapper: convert errors into fallback values
  //     (demonstrates error handling and fallback strategy)
  // ----------------------------
  Stream<T> withFallback<T>(Stream<T> input, T fallback) {
    final controller = StreamController<T>();

    input.listen(
      (event) {
        controller.add(event);
      },
      onError: (err, st) {
        // Convert any error into a fallback value
        controller.add(fallback);
      },
      onDone: () {
        controller.close();
      },
      cancelOnError: false,
    );

    return controller.stream;
  }

  // ----------------------------
  // 12) Stream that maps async results (streams of futures)
  // ----------------------------
  Stream<T> mapFutureResults<T>(Stream<Future<T>> input) async* {
    await for (final f in input) {
      // await each Future and yield its resolved value
      yield await f;
    }
  }

  // ----------------------------
  // Cleanup
  // ----------------------------
  Future<void> dispose() async {
    if (!_broadcastController.isClosed) await _broadcastController.close();
    await _singleController?.close();
  }
}
