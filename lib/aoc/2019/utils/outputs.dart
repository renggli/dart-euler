import 'dart:io';

abstract interface class Output {
  void put(int value);
}

class NullOutput implements Output {
  const NullOutput();

  @override
  void put(int value) {}
}

class ListOutput implements Output {
  final List<int> list = [];

  @override
  void put(int value) => list.add(value);
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