import 'dart:io';

import 'package:more/char_matcher.dart';

import 'constants.dart';
import 'inputs.dart';
import 'outputs.dart';

class Machine {
  factory Machine.fromFile(File file, {Input? input, Output? output}) =>
      Machine(file.readAsStringSync().split(',').map(int.parse),
          input: input, output: output);

  Machine(Iterable<int> memory, {Input? input, Output? output})
      : memory = memory.toList(),
        input = input ?? const NullInput(),
        output = output ?? const NullOutput();

  final List<int> memory;
  int instructionPointer = 0;
  int relativeBase = 0;

  Input input;
  Output output;

  /// Runs the program to completion.
  void run() {
    while (step()) {}
  }

  /// Performs a single execution step. Returns `false` if the program terminated.
  bool step() {
    switch (memory[instructionPointer] % opMask) {
      case OpCode.add:
        _write(3, _read(1) + _read(2));
        instructionPointer += 4;
      case OpCode.mul:
        _write(3, _read(1) * _read(2));
        instructionPointer += 4;
      case OpCode.get:
        _write(1, input.get());
        instructionPointer += 2;
      case OpCode.put:
        output.put(_read(1));
        instructionPointer += 2;
      case OpCode.jumpIfTrue:
        instructionPointer = _read(1) != 0 ? _read(2) : instructionPointer + 3;
      case OpCode.jumpIfFalse:
        instructionPointer = _read(1) == 0 ? _read(2) : instructionPointer + 3;
      case OpCode.lessThan:
        _write(3, _read(1) < _read(2) ? 1 : 0);
        instructionPointer += 4;
      case OpCode.equals:
        _write(3, _read(1) == _read(2) ? 1 : 0);
        instructionPointer += 4;
      case OpCode.adjustRelativeBase:
        relativeBase += _read(1);
        instructionPointer += 2;
      case OpCode.exit:
        instructionPointer += 1;
        return false;
      default:
        throw StateError('Invalid op code at $instructionPointer: '
            '${decodePoint(instructionPointer)}');
    }
    return true;
  }

  /// Decodes the address pointer of a parameter at the current instruction.
  int _address(int param) {
    final mode = memory[instructionPointer] ~/ addressModes[param]!;
    switch (mode % addressModeMask) {
      case AddressMode.position:
        return memory[instructionPointer + param];
      case AddressMode.immediate:
        return instructionPointer + param;
      case AddressMode.relative:
        return memory[instructionPointer + param] + relativeBase;
      default:
        throw StateError('Invalid address at $instructionPointer param $param:'
            '${decodePoint(instructionPointer)}');
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

  /// Write a value of a parameter at the current instruction.
  void _write(int param, int value) {
    final address = _address(param);
    _grow(address);
    memory[address] = value;
  }

  /// Decodes to a list of strings.
  List<String> decode({int start = 0, int? end}) => decodeRange(
          start: start, end: end)
      .entries
      .map((entry) => '${entry.key.toString().padLeft(4, '0')} ${entry.value}')
      .toList();

  /// Decodes (part of) the memory.
  Map<int, String> decodeRange({int start = 0, int? end}) {
    end ??= memory.length;
    final result = <int, String>{};
    for (var index = start; index < end && index < memory.length;) {
      result[index] = decodePoint(index);
      index += opLength[memory[index] % opMask] ?? 1;
    }
    return result;
  }

  /// Decodes a single operation at the provided index.
  String decodePoint(int index) {
    final code = memory[index];
    final operation = code % opMask;
    final name = opName[operation];
    final buffer = StringBuffer();
    if (name != null) {
      buffer.write(name);
      for (var param = 1; param < opLength[operation]!; param++) {
        buffer.write(param == 1 ? ' ' : ', ');
        buffer.write(decodeParam(index, param));
      }
    } else {
      buffer.write('?$code');
      if (_printable.match(code)) {
        buffer.write(' "${String.fromCharCode(code)}"');
      }
    }
    return buffer.toString();
  }

  /// Decodes a single parameter at the provided index.
  String decodeParam(int index, int param) {
    final mode = memory[index] ~/ addressModes[param]!;
    final value =
        index + param < memory.length ? '${memory[index + param]}' : '?';
    switch (mode % addressModeMask) {
      case AddressMode.position:
        return '[$value]';
      case AddressMode.immediate:
        return value;
      case AddressMode.relative:
        return value.startsWith('-') ? '[rb$value]' : '[rb+$value]';
      default:
        return '$mode?$value';
    }
  }
}

final _printable = const CharMatcher.letter() |
    const CharMatcher.digit() |
    const CharMatcher.punctuation() |
    CharMatcher.isChar(' ');
