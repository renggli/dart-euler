import 'dart:math';

import 'package:test/test.dart';

import 'inputs.dart';
import 'machine.dart';
import 'outputs.dart';

void main() {
  group('dec 02', () {
    Iterable<int> run(Iterable<int> input) {
      final machine = Machine(input);
      machine.run();
      return machine.memory;
    }

    test('simple program', () {
      expect(run([1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]),
          [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50]);
    });
    test('other examples', () {
      expect(run([1, 0, 0, 0, 99]), [2, 0, 0, 0, 99]);
      expect(run([2, 3, 0, 3, 99]), [2, 3, 0, 6, 99]);
      expect(run([2, 4, 4, 5, 99, 0]), [2, 4, 4, 5, 99, 9801]);
      expect(run([1, 1, 1, 4, 99, 5, 6, 0, 99]), [30, 1, 1, 4, 2, 5, 6, 0, 99]);
    });
  });
  group('dec 05', () {
    Iterable<int> run(Iterable<int> memory, Iterable<int> params) {
      final input = ListInput(params), output = ListOutput();
      Machine(memory, input: input, output: output).run();
      return output.list;
    }

    test('output whatever we got as input', () {
      final random = Random(42);
      for (var i = 0; i < 100; i++) {
        final value = random.nextInt(10000) - 5000;
        expect(run([3, 0, 4, 0, 99], [value]), [value]);
      }
    });
    test('position mode: equal to 8', () {
      final memory = [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8];
      expect(run(memory, [7]), [0]);
      expect(run(memory, [8]), [1]);
      expect(run(memory, [9]), [0]);
    });
    test('position mode: less than 8', () {
      final memory = [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8];
      expect(run(memory, [7]), [1]);
      expect(run(memory, [8]), [0]);
      expect(run(memory, [9]), [0]);
    });
    test('position mode: test for non-zero', () {
      final memory = [3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9];
      expect(run(memory, [-3]), [1]);
      expect(run(memory, [0]), [0]);
      expect(run(memory, [42]), [1]);
    });
    test('immediate mode: equal to 8', () {
      final memory = [3, 3, 1108, -1, 8, 3, 4, 3, 99];
      expect(run(memory, [7]), [0]);
      expect(run(memory, [8]), [1]);
      expect(run(memory, [9]), [0]);
    });
    test('immediate mode: less than 8', () {
      final memory = [3, 3, 1107, -1, 8, 3, 4, 3, 99];
      expect(run(memory, [7]), [1]);
      expect(run(memory, [8]), [0]);
      expect(run(memory, [9]), [0]);
    });
    test('immediate mode: test for non-zero', () {
      final memory = [3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1];
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
      expect(run(memory), memory);
    });
    test('16 digit number', () {
      final memory = [1102, 34915192, 34915192, 7, 4, 7, 99, 0];
      expect(run(memory), [1219070632396864]);
    });
    test('large number', () {
      final memory = [104, 1125899906842624, 99];
      expect(run(memory), [memory[1]]);
    });
  });
}