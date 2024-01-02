abstract interface class Input {
  int get();
}

class NullInput implements Input {
  const NullInput();

  @override
  int get() => throw StateError('No input provided');
}

class ListInput implements Input {
  ListInput([this.input = const []]) : iterator = input.iterator;

  final Iterable<int> input;
  final Iterator<int> iterator;

  @override
  int get() {
    if (iterator.moveNext()) return iterator.current;
    throw StateError('No more input available');
  }
}
