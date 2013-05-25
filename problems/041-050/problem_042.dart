/**
 * Problem 42: Coded triangle numbers
 *
 * The n-th term of te sequence of triangle numbers is given by
 *
 *    t_n = 0.5 * n * (n + 1)
 *
 * so the first thn traingle numbers are:
 *
 *    1, 3, 6, 10, 15, 21, 28, 36, 45, 55, ...
 *
 * By converting each letter in a word to a number corresponding to its
 * alphabetical position and adding these values we form a word value. For
 * example, the word value for SKY is 19 + 11 + 25 = 55 = t_10. If the word
 * value is a triangle number we shall call the word a triangle word.
 *
 * Using words.txt (right click and save), a 16K text file containing nearly
 * 2000 common english words, how many are triangle words.
 */
library problem_042;

import 'dart:io';

import 'package:more/char_matcher.dart';
import 'package:more/int_math.dart';
import 'package:more/iterable.dart';
import 'package:more/range.dart';

final traingleNumbers = range(1000)
    .map((value) => value * (value + 1) ~/ 2)
    .toSet();

final baseOffset = 'A'.codeUnitAt(0) - 1;

final timmer = isChar('"');

int wordValue(String word) {
  return word.toUpperCase().codeUnits
      .map((each) => each - baseOffset)
      .reduce((a, b) => a + b);
}

void main() {
  assert(new File('words.txt')
      .readAsStringSync()
      .split(',')
      .map((each) => timmer.trimFrom(each))
      .where((each) => traingleNumbers.contains(wordValue(each)))
      .length == 162);
}