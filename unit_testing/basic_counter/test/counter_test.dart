import 'package:basic_counter/counter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Counter counter;
  // Pre-Test function
  setUp(() {
    counter = Counter();
  });
  // Given When Then
  group('Counter Class - ', () {
    test(
        'Given counter class when it is instantiated then value of the count should be 0',
        () {
      // Act
      final val = counter.count;
      // Assert
      expect(val, 0);
    });


    test(
        'Given counter class when incrementCount() is called then the value of the count should be 1',
        () {
      // Act
      counter.incrementCount();
      final val = counter.count;

      // Assert
      expect(val, 1);
    });

    test(
        'Given counter class when decrementCount() is called then the value of the count should be -1',
        () {
      // Act
      counter.decrementCount();
      final val = counter.count;
      // Assert
      expect(val, -1);
    });
  });
}
