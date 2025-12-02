import 'package:cleanarchexample/testing/unit_testing_practice/simple_tests.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SimpleTests simpleTests;
  setUp(() {
    simpleTests = SimpleTests();
  });
  group("SimpleTest greeting tests", () {
    test('Happy case', () {
      //Arrange
      //Act
      final res = simpleTests.greet("Arab");
      //Assert
      expect(res, "Hello Arab");
      expect(res, isNotNull);
    });

    test('Empty Case', () {
      //Arrange
      //Act
      final res = simpleTests.greet("");
      //Assert
      expect(res, "Hello ");
      expect(res, isNotNull);
    });
  });

  group("SimpleTest maxValue tests", () {
    test('a > b', () {
      //Arrange
      //Act
      final res = simpleTests.maxValue(6, 3);
      //Assert
      expect(res, 6);
      expect(res, isNotNull);
    });

    test('b > a', () {
      //Arrange
      //Act
      final res = simpleTests.maxValue(3, 6);
      //Assert
      expect(res, 6);
      expect(res, isNotNull);
    });
  });

  group("SimpleTest parseAge tests", () {
    test('valid input', () {
      //Arrange
      //Act
      final res = simpleTests.parseAge("25");
      //Assert
      expect(res, 25);
      expect(res, isNotNull);
    });

    test('invalid input', () {
      //Assert
      expect(
        () => simpleTests.parseAge("abc"),
        throwsA(
          isA<FormatException>(),
        ),
      );
    });
  });
}
