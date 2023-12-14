import 'dart:io';
import 'package:more/more.dart';

List<List<String>> read() => File('lib/aoc/2023/dec_14.txt')
    .readAsLinesSync()
    .map((line) => line.toList(mutable: true))
    .toList();

void tilt(List<List<String>> data, final int dx, final int dy) {
  final rx = 0.to(data.length), ry = 0.to(data[0].length);
  for (final x in dx != 1 ? rx : rx.reversed) {
    for (final y in dy != 1 ? ry : ry.reversed) {
      if (data[x][y] == 'O') {
        var ox = x, oy = y;
        while (0 <= ox + dx &&
            ox + dx < data.length &&
            0 <= oy + dy &&
            oy + dy < data[0].length &&
            data[ox + dx][oy + dy] == '.') {
          ox += dx;
          oy += dy;
        }
        if (x != ox || y != oy) {
          data[x][y] = '.';
          data[ox][oy] = 'O';
        }
      }
    }
  }
}

int load(List<List<String>> data) {
  var result = 0;
  for (var x = 0; x < data.length; x++) {
    for (var y = 0; y < data[x].length; y++) {
      if (data[x][y] == 'O') {
        result += data.length - x;
      }
    }
  }
  return result;
}

int problem1() {
  final data = read();
  tilt(data, -1, 0); // north
  return load(data);
}

int problem2({int cycles = 1000000000}) {
  final data = read();
  final seen = <String, int>{};
  for (var i = 0; i < cycles; i++) {
    tilt(data, -1, 0); // north
    tilt(data, 0, -1); // west
    tilt(data, 1, 0); // south
    tilt(data, 0, 1); // east
    final string = data.join('\n');
    final last = seen[string];
    if (last != null) {
      // Jump to the last cycle
      final diff = i - last;
      i += (cycles - i) ~/ diff * diff;
    }
    seen[string] = i;
  }
  return load(data);
}

void main() {
  assert(problem1() == 113486);
  assert(problem2() == 104409);
}
