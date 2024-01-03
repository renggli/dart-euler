import 'dart:io';

import 'package:collection/collection.dart';

abstract interface class Output {
  void put(int value);
}

class NullOutput implements Output {
  const NullOutput();

  @override
  void put(int value) {}
}

class ListOutput implements Output {
  final list = QueueList<int>();

  @override
  void put(int value) => list.addLast(value);
}

class StringOutput implements Output {
  final buffer = StringBuffer();

  @override
  void put(int value) => buffer.writeCharCode(value);
}

class StdoutOutput implements Output {
  @override
  void put(int value) => stdout.writeCharCode(value);
}
