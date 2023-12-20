import 'dart:io';

import 'inputs.dart';
import 'outputs.dart';

class Machine {
  factory Machine.fromFile(File file, {Input? input, Output? output}) =>
      Machine(file.readAsStringSync().split(',').map(int.parse),
          input: input, output: output);

  Machine(Iterable<int> memory, {Input? input, Output? output})
      : memory = memory.toList(),
        input = input ?? NullInput(),
        output = output ?? NullOutput();

  List<int> memory;
  int instructionPointer = 0;
  int relativeBase = 0;

  Input input;
  Output output;

  /// Runs the program to completion, and returns the output.
  void run() {
    while (step()) {}
  }

  /// Performs a single execution step. Returns `false` if the program terminated.
  bool step() {
    switch (memory[instructionPointer] % 100) {
      case 1: // plus
        _write(3, _read(1) + _read(2));
        instructionPointer += 4;
      case 2: // multiply
        _write(3, _read(1) * _read(2));
        instructionPointer += 4;
      case 3: // input
        _write(1, input.get());
        instructionPointer += 2;
      case 4: // output
        output.put(_read(1));
        instructionPointer += 2;
      case 5: // jump-if-true
        instructionPointer = _read(1) != 0 ? _read(2) : instructionPointer + 3;
      case 6: // jump-if-false
        instructionPointer = _read(1) == 0 ? _read(2) : instructionPointer += 3;
      case 7: // less than
        _write(3, _read(1) < _read(2) ? 1 : 0);
        instructionPointer += 4;
      case 8: // equals
        _write(3, _read(1) == _read(2) ? 1 : 0);
        instructionPointer += 4;
      case 9: // adjust-relative-base
        relativeBase += _read(1);
        instructionPointer += 2;
      case 99: // exit
        instructionPointer += 1;
        return false;
      default:
        throw StateError('Invalid op code ${memory[instructionPointer]} '
            'at $instructionPointer');
    }
    return true;
  }

  /// Decodes the address pointer of a parameter at the current instruction.
  int _address(int param) {
    const params = {1: 100, 2: 1000, 3: 10000};
    final mode = memory[instructionPointer] ~/ params[param]!;
    switch (mode % 10) {
      case 0: // position mode
        return memory[instructionPointer + param];
      case 1: // immediate mode
        return instructionPointer + param;
      case 2: // relative mode
        return memory[instructionPointer + param] + relativeBase;
      default:
        throw StateError('Invalid op code ${memory[instructionPointer]} '
            'at $instructionPointer: invalid address mode of param $param');
    }
  }

  /// Grows the memory to accommodate the provided address.
  void _grow(int address) {
    while (memory.length <= address) {
      memory.add(0);
    }
  }

  /// Read a value of a parameter at the current instruction.
  int _read(int param) {
    final address = _address(param);
    _grow(address);
    return memory[address];
  }

  // Write a value of a parameter at the current instruction.
  void _write(int param, int value) {
    final address = _address(param);
    _grow(address);
    memory[address] = value;
  }
}
