import 'dart:io';

abstract interface class Input {
  int get();
}

class NullInput implements Input {
  const NullInput();

  @override
  int get() => throw StateError('No input provided');
}

class ListInput implements Input {
  ListInput([this.iterable = const []]) : iterator = iterable.iterator;

  final Iterable<int> iterable;
  final Iterator<int> iterator;

  @override
  int get() {
    if (iterator.moveNext()) return iterator.current;
    throw StateError('No more input available');
  }
}

class StdinInput implements Input {
  @override
  int get() => stdin.readByteSync();
}
