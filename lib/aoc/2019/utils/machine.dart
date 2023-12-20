import 'dart:io';

class Machine {
  factory Machine.fromFile(File file, {Iterable<int> input = const []}) =>
      Machine(file.readAsStringSync().split(',').map(int.parse), input: input);

  Machine(Iterable<int> memory, {Iterable<int> input = const []})
      : memory = memory.toList(growable: false),
        input = input.toList(growable: false);

  final List<int> memory;
  int instructionPointer = 0;

  final List<int> input;
  int inputPointer = 0;

  final List<int> output = [];

  List<int> run() {
    while (true) {
      switch (memory[instructionPointer] % 100) {
        case 1: // plus
          _write(3, _read(1) + _read(2));
          instructionPointer += 4;
        case 2: // multiply
          _write(3, _read(1) * _read(2));
          instructionPointer += 4;
        case 3: // input
          _write(1, input[inputPointer++]);
          instructionPointer += 2;
        case 4: // output
          output.add(_read(1));
          instructionPointer += 2;
        case 5: // jump-if-true
          instructionPointer =
              _read(1) != 0 ? _read(2) : instructionPointer + 3;
        case 6: // jump-if-false
          instructionPointer =
              _read(1) == 0 ? _read(2) : instructionPointer += 3;
        case 7: // less than
          _write(3, _read(1) < _read(2) ? 1 : 0);
          instructionPointer += 4;
        case 8: // equals
          _write(3, _read(1) == _read(2) ? 1 : 0);
          instructionPointer += 4;
        case 99: // exit
          return output;
        default:
          throw StateError('Invalid op code ${memory[instructionPointer]} '
              'at $instructionPointer');
      }
    }
  }

  static const _params = {1: 100, 2: 1000, 3: 10000};

  int _read(int param) {
    final mode = memory[instructionPointer] ~/ _params[param]!;
    switch (mode % 10) {
      case 0: // position mode
        return memory[memory[instructionPointer + param]];
      case 1: // immediate mode
        return memory[instructionPointer + param];
      default:
        throw StateError('Invalid op code ${memory[instructionPointer]} '
            'at $instructionPointer: invalid read mode of param $param');
    }
  }

  void _write(int param, int value) {
    final mode = memory[instructionPointer] ~/ _params[param]!;
    switch (mode % 10) {
      case 0: // position mode
        memory[memory[instructionPointer + param]] = value;
      default:
        throw StateError('Invalid op code ${memory[instructionPointer]} '
            'at $instructionPointer: invalid write mode of param $param');
    }
  }
}
