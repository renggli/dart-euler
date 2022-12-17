import 'dart:io';

import 'package:more/more.dart';

int binarySearch(String values, int min, int max, bool lower) {
  for (final value in values.split('')) {
    final mid = min + (max - min) ~/ 2;
    if (value == 'F' || value == 'L') {
      max = mid;
    } else if (value == 'B' || value == 'R') {
      min = mid + 1;
    }
  }
  return lower ? min : max;
}

int getSeat(String input) {
  final row = binarySearch(input.substring(0, 7), 0, 127, true);
  final col = binarySearch(input.substring(7), 0, 7, false);
  return row * 8 + col;
}

const Comparator<int> comparator = naturalComparable<num>;
final seats =
    File('lib/aoc/2020/dec_05.txt').readAsLinesSync().map(getSeat).toSet();

void main() {
  final maxSeat = seats.max();
  final minSeat = seats.min();
  assert(maxSeat == 926);

  final freeSeats = minSeat.to(maxSeat).toSet().difference(seats);
  assert(freeSeats.single == 657);
}
