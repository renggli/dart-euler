import 'dart:collection';
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
  ListInput([Iterable<int> iterable = const []]) {
    list.addAll(iterable);
  }

  final list = ListQueue<int>();

  @override
  int get() {
    if (list.isEmpty) throw StateError('No input available');
    return list.removeFirst();
  }
}

class StdinInput implements Input {
  @override
  int get() => stdin.readByteSync();
}
