import 'dart:math';

import 'package:test/test.dart';

import 'inputs.dart';
import 'machine.dart';
import 'outputs.dart';

List<String> decode(List<int> memory, {int start = 0, int? end}) =>
    Machine(memory).decode(start: start, end: end);

void main() {
  group('dec 02', () {
    Iterable<int> run(Iterable<int> input) {
      final machine = Machine(input);
      machine.run();
      return machine.memory;
    }

    test('simple program', () {
      const memory = [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50];
      expect(decode(memory), [
        '0000 add [9], [10], [3]',
        '0004 mul [3], [11], [0]',
        '0008 exit',
        '0009 ?30',
        '0010 ?40 "("',
        '0011 ?50 "2"',
      ]);
      expect(run(memory), [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50]);
    });
    test('other example 1', () {
      const memory = [1, 0, 0, 0, 99];
      expect(decode(memory), [
        '0000 add [0], [0], [0]',
        '0004 exit',
      ]);
      expect(run(memory), [2, 0, 0, 0, 99]);
    });
    test('other example 2', () {
      const memory = [2, 3, 0, 3, 99];
      expect(decode(memory), [
        '0000 mul [3], [0], [3]',
        '0004 exit',
      ]);
      expect(run(memory), [2, 3, 0, 6, 99]);
    });
    test('other example 3', () {
      const memory = [2, 4, 4, 5, 99, 0];
      expect(decode(memory), [
        '0000 mul [4], [4], [5]',
        '0004 exit',
        '0005 ?0',
      ]);
      expect(run(memory), [2, 4, 4, 5, 99, 9801]);
    });
    test('other example 4', () {
      const memory = [1, 1, 1, 4, 99, 5, 6, 0, 99];
      expect(decode(memory), [
        '0000 add [1], [1], [4]',
        '0004 exit',
        '0005 jump-if-true [6], [0]',
        '0008 exit',
      ]);
      expect(run(memory), [30, 1, 1, 4, 2, 5, 6, 0, 99]);
    });
  });
  group('dec 05', () {
    Iterable<int> run(Iterable<int> memory, Iterable<int> params) {
      final input = ListInput(params), output = ListOutput();
      Machine(memory, input: input, output: output).run();
      return output.list;
    }

    test('output whatever we got as input', () {
      const memory = [3, 0, 4, 0, 99];
      expect(decode(memory), [
        '0000 get [0]',
        '0002 put [0]',
        '0004 exit',
      ]);
      final random = Random(42);
      for (var i = 0; i < 100; i++) {
        final value = random.nextInt(10000) - 5000;
        expect(run(memory, [value]), [value]);
      }
    });
    test('position mode: equal to 8', () {
      final memory = [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8];
      expect(decode(memory, end: 9), [
        '0000 get [9]',
        '0002 equals [9], [10], [9]',
        '0006 put [9]',
        '0008 exit',
      ]);
      expect(run(memory, [7]), [0]);
      expect(run(memory, [8]), [1]);
      expect(run(memory, [9]), [0]);
    });
    test('position mode: less than 8', () {
      final memory = [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8];
      expect(decode(memory, end: 9), [
        '0000 get [9]',
        '0002 less-than [9], [10], [9]',
        '0006 put [9]',
        '0008 exit',
      ]);
      expect(run(memory, [7]), [1]);
      expect(run(memory, [8]), [0]);
      expect(run(memory, [9]), [0]);
    });
    test('position mode: test for non-zero', () {
      final memory = [3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9];
      expect(decode(memory, end: 12), [
        '0000 get [12]',
        '0002 jump-if-false [12], [15]',
        '0005 add [13], [14], [13]',
        '0009 put [13]',
        '0011 exit',
      ]);
      expect(run(memory, [-3]), [1]);
      expect(run(memory, [0]), [0]);
      expect(run(memory, [42]), [1]);
    });
    test('immediate mode: equal to 8', () {
      final memory = [3, 3, 1108, -1, 8, 3, 4, 3, 99];
      expect(decode(memory), [
        '0000 get [3]',
        '0002 equals -1, 8, [3]',
        '0006 put [3]',
        '0008 exit',
      ]);
      expect(run(memory, [7]), [0]);
      expect(run(memory, [8]), [1]);
      expect(run(memory, [9]), [0]);
    });
    test('immediate mode: less than 8', () {
      final memory = [3, 3, 1107, -1, 8, 3, 4, 3, 99];
      expect(decode(memory), [
        '0000 get [3]',
        '0002 less-than -1, 8, [3]',
        '0006 put [3]',
        '0008 exit',
      ]);
      expect(run(memory, [7]), [1]);
      expect(run(memory, [8]), [0]);
      expect(run(memory, [9]), [0]);
    });
    test('immediate mode: test for non-zero', () {
      final memory = [3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1];
      expect(decode(memory, end: 12), [
        '0000 get [3]',
        '0002 jump-if-true -1, 9',
        '0005 add 0, 0, [12]',
        '0009 put [12]',
        '0011 exit',
      ]);
      expect(run(memory, [-3]), [1]);
      expect(run(memory, [0]), [0]);
      expect(run(memory, [42]), [1]);
    });
    test('larger example', () {
      final memory = [
        3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21, 20, 1006, 20, 31, //
        1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20, 1105, 1, 46, 104,
        999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105, 1, 46, 98, 99,
      ];
      expect(decode(memory), [
        '0000 get [21]',
        '0002 equals [21], 8, [20]',
        '0006 jump-if-true [20], 22',
        '0009 less-than 8, [21], [20]',
        '0013 jump-if-false [20], 31',
        '0016 jump-if-false 0, 36',
        '0019 ?98 "b"',
        '0020 ?0',
        '0021 ?0',
        '0022 mul [21], 125, [20]',
        '0026 put [20]',
        '0028 jump-if-true 1, 46',
        '0031 put 999',
        '0033 jump-if-true 1, 46',
        '0036 add 1000, 1, [20]',
        '0040 put [20]',
        '0042 jump-if-true 1, 46',
        '0045 ?98 "b"',
        '0046 exit',
      ]);
      expect(run(memory, [7]), [999]);
      expect(run(memory, [8]), [1000]);
      expect(run(memory, [9]), [1001]);
    });
  });
  group('dec 09', () {
    Iterable<int> run(Iterable<int> memory) {
      final output = ListOutput();
      Machine(memory, output: output).run();
      return output.list;
    }

    test('copy of itself', () {
      final memory = [
        109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, //
        0, 99,
      ];
      expect(decode(memory), [
        '0000 adjust-relative-base 1',
        '0002 put [rb-1]',
        '0004 add [100], 1, [100]',
        '0008 equals [100], 16, [101]',
        '0012 jump-if-false [101], 0',
        '0015 exit'
      ]);
      expect(run(memory), memory);
    });
    test('16 digit number', () {
      final memory = [1102, 34915192, 34915192, 7, 4, 7, 99, 0];
      expect(decode(memory), [
        '0000 mul 34915192, 34915192, [7]',
        '0004 put [7]',
        '0006 exit',
        '0007 ?0',
      ]);
      expect(run(memory), [1219070632396864]);
    });
    test('large number', () {
      final memory = [104, 1125899906842624, 99];
      expect(decode(memory), [
        '0000 put 1125899906842624',
        '0002 exit',
      ]);
      expect(run(memory), [memory[1]]);
    });
  });
}
