abstract interface class Output {
  void put(int value);
}

class NullOutput implements Output {
  @override
  void put(int value) {}
}

class ListOutput implements Output {
  final List<int> list = [];

  @override
  void put(int value) => list.add(value);
}
