import 'dart:io';

final values =
    File('lib/aoc2020/dec_25.txt').readAsLinesSync().map(int.parse).toList();

int loopSize(int publicKey) {
  var value = 1;
  for (var size = 1;; size++) {
    value = (value * 7) % 20201227;
    if (value == publicKey) {
      return size;
    }
  }
}

int solve(int subject, int loop) {
  var value = 1;
  for (var i = 0; i < loop; i++) {
    value = (value * subject) % 20201227;
  }
  return value;
}

void main() {
  assert(solve(values[0], loopSize(values[1])) == 3015200);
}
