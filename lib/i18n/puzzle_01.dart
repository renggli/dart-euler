import 'dart:convert';
import 'dart:io';

import 'package:characters/characters.dart';

int run(String filename) {
  var total = 0;
  for (final line in File(filename).readAsLinesSync()) {
    final byteSize = utf8.encode(line).length;
    final charSize = line.characters.length;
    final isSms = byteSize <= 160;
    final isTweet = charSize <= 140;
    final price = isSms && isTweet
        ? 13
        : isSms
        ? 11
        : isTweet
        ? 7
        : 0;
    total += price;
  }
  return total;
}

void main() {
  assert(run('lib/i18n/puzzle_01_test.txt') == 31);
  assert(run('lib/i18n/puzzle_01_input.txt') == 107989);
}
