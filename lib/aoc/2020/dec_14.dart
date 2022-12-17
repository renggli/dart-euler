import 'dart:io';

import 'package:data/stats.dart';
import 'package:more/more.dart';

final values = File('lib/aoc/2020/dec_14.txt').readAsLinesSync();

final command = RegExp(r'((mask) = ([X10]{36})|(mem)\[(\d+)\] = (\d+))');

const bitSize = 36;

int run(
    void Function(Map<int, int> memory, String mask, int address, int value)
        callback) {
  var mask = '';
  final memory = <int, int>{};
  for (final value in values) {
    final match = command.matchAsPrefix(value);
    if (match == null) {
      throw StateError('Invalid command: $value');
    } else if (match.group(2) == 'mask') {
      mask = match.group(3)!;
    } else if (match.group(4) == 'mem') {
      final address = int.parse(match.group(5)!);
      final value = int.parse(match.group(6)!);
      callback(memory, mask, address, value);
    }
  }
  return memory.values.sum();
}

void problem1(Map<int, int> memory, String mask, int address, int value) {
  final binaryValue = value.toRadixString(2).padLeft(bitSize, '0').split('');
  final transformed = binaryValue
      .indexed()
      .map((each) => mask[each.index] != 'X' ? mask[each.index] : each.value)
      .join();
  memory[address] = int.parse(transformed, radix: 2);
}

void problem2(Map<int, int> memory, String mask, int address, int value) {
  final binaryAddress =
      address.toRadixString(2).padLeft(bitSize, '0').split('');
  final addresses = [binaryAddress];
  for (var i = 0; i < bitSize; i++) {
    if (mask[i] == '1') {
      for (final address in addresses) {
        address[i] = '1';
      }
    } else if (mask[i] == 'X') {
      for (final address in addresses) {
        address[i] = '0';
      }
      addresses.addAll(addresses.map((address) {
        final copy = address.toList();
        copy[i] = '1';
        return copy;
      }).toList());
    }
  }
  addresses
      .map((address) => int.parse(address.join(), radix: 2))
      .forEach((address) => memory[address] = value);
}

void main() {
  assert(run(problem1) == 15403588588538);
  assert(run(problem2) == 3260587250457);
}
