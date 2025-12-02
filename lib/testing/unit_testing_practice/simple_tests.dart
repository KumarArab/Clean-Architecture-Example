class SimpleTests {
  String greet(String name) {
    return "Hello $name";
  }

  int maxValue(int a, int b) {
    return a > b ? a : b;
  }

  int parseAge(String input) {
    final value = int.tryParse(input);
    if (value == null) throw FormatException('Invalid age');
    return value;
  }
}
