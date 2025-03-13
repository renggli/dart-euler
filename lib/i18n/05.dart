import 'dart:io';

import 'package:characters/characters.dart';

int run(String filename) {
  var poop = 0, index = 0;
  for (final line in File(filename).readAsLinesSync()) {
    final characters = line.characters;
    if (characters.elementAt(index % characters.length) == '💩') poop++;
    index += 2;
  }
  return poop;
}

void main() {
  assert(run('lib/i18n/05-test.txt') == 2);
  assert(run('lib/i18n/05-input.txt') == 74);
}
