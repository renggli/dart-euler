import 'dart:io';

import 'package:data/stats.dart';

const outside = ' ';
const floor = '.';
const empty = 'L';
const occupied = '#';

final values = File('lib/aoc2020/dec_11.txt')
    .readAsLinesSync()
    .map((line) => line.split(''))
    .toList();

String seatAt(List<List<String>> input, int x, int y) =>
    0 <= x && x < input.length && 0 <= y && y < input[x].length
        ? input[x][y]
        : ' ';

int directlyOccupied(List<List<String>> input, int x, int y) {
  var count = 0;
  for (var i = x - 1; i <= x + 1; i++) {
    for (var j = y - 1; j <= y + 1; j++) {
      if (!(i == x && j == y) && seatAt(input, i, j) == occupied) {
        count++;
      }
    }
  }
  return count;
}

int indirectlyOccupied(List<List<String>> input, int x, int y) {
  var count = 0;
  for (final dx in [-1, 0, 1]) {
    for (final dy in [-1, 0, 1]) {
      if (!(dx == 0 && dy == 0)) {
        for (var i = 1;; i++) {
          final seat = seatAt(input, x + dx * i, y + dy * i);
          if (seat == outside || seat == empty) {
            break;
          } else if (seat == occupied) {
            count++;
            break;
          }
        }
      }
    }
  }
  return count;
}

List<List<String>>? run(
    List<List<String>> input,
    int Function(List<List<String>>, int, int) occupancyCounter,
    int maxOccupancy) {
  var hasChanged = false;
  final output = input.map((row) => row.toList()).toList();
  for (var x = 0; x < input.length; x++) {
    for (var y = 0; y < input[x].length; y++) {
      final seat = input[x][y];
      final count = occupancyCounter(input, x, y);
      if (seat == empty && count == 0) {
        output[x][y] = occupied;
        hasChanged = true;
      } else if (seat == occupied && count >= maxOccupancy) {
        output[x][y] = empty;
        hasChanged = true;
      }
    }
  }
  return hasChanged ? output : null;
}

int runAll(List<List<String>>? Function(List<List<String>>) run) {
  var input = values;
  for (;;) {
    final current = run(input);
    if (current != null) {
      input = current;
    } else {
      break;
    }
  }
  return input.map((row) => row.where((seat) => seat == occupied).length).sum();
}

void main() {
  assert(runAll((input) => run(input, directlyOccupied, 4)) == 2453);
  assert(runAll((input) => run(input, indirectlyOccupied, 5)) == 2159);
}
