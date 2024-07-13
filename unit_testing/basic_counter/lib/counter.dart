class Counter {
  int _counter = 0;

  int get count => _counter;

  void incrementCount() {
    _counter++;
  }

  void decrementCount() {
    _counter--;
  }

  void resetCounter() {
    _counter = 0;
  }
}