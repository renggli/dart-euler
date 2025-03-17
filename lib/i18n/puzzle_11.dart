import 'dart:io';

import 'package:data/data.dart';
import 'package:more/collection.dart';

final greek = [
  'αβγδεζηθικλμνξοπρστυφχψω'.toList(),
  'ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ'.toList(),
];

const odysseus = ['Οδυσσευς', 'Οδυσσεως', 'Οδυσσει', 'Οδυσσεα', 'Οδυσσευ'];

String rotate(String input, int distance) => input.toList().map((char) {
    if (char == '\u03C2') char = '\u03c3';
    for (final mapping in greek) {
      final index = mapping.indexOf(char);
      if (index >= 0) return mapping[(index + distance) % mapping.length];
    }
    return char;
  }).join();

int run(String filename) => File(filename).readAsLinesSync().map((line) {
    for (var index = 0; index < greek.first.length; index++) {
      if (odysseus.any(rotate(line, index).contains)) return index;
    }
    return 0;
  }).sum();

void main() {
  assert(run('lib/i18n/puzzle_11_test.txt') == 19);
  assert(run('lib/i18n/puzzle_11_input.txt') == 365);
}
