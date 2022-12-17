import 'dart:io';

final values = File('lib/aoc/2020/dec_01.txt').readAsLinesSync().map(int.parse);

void main() {
  for (final a in values) {
    for (final b in values) {
      if (a + b == 2020) {
        assert(a * b == 719796);
        break;
      }
    }
  }
  for (final a in values) {
    for (final b in values) {
      for (final c in values) {
        if (a + b + c == 2020) {
          assert(a * b * c == 144554112);
          break;
        }
      }
    }
  }
}
