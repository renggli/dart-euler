import 'dart:convert';
import 'dart:io';

import 'package:more/collection.dart';

String decode(List<int> bytes) => utf8.decode(bytes, allowMalformed: true);

bool isValid(String bytes) =>
    !bytes.runes.contains(unicodeReplacementCharacterRune);

List<List<int>> copy(List<List<int>> block) => [
  for (final line in block) [for (final byte in line) byte],
];

void printBlock(List<List<int>> block) {
  for (final line in block) {
    if (line.every((byte) => byte == 0)) break;
    final index = line.lastIndexWhere((byte) => byte != 0);
    final string = decode(line.sublist(0, index + 1));
    stdout.writeln(isValid(string) ? string : '$string <<< INVALID');
  }
}

int run(String filename) {
  final blocks = File(filename)
      .readAsStringSync()
      .split('\n\n')
      .map(
        (block) => block
            .split('\n')
            .map(
              (line) => line
                  .chunked(2)
                  .map((byte) => int.parse(byte, radix: 16))
                  .toList(),
            )
            .toList(),
      )
      .toList();

  // identify the upper left corner
  final upperLeft = blocks.singleWhere(
    (block) => utf8.decode(block[0], allowMalformed: true).startsWith('╔'),
  );
  blocks.remove(upperLeft);

  // create a large enough result grid large enough
  final result = copy(upperLeft);
  while (result.length <= 100) {
    result.add([]);
  }
  for (final line in result) {
    while (line.length <= 100) {
      line.add(0);
    }
  }

  printBlock(result);

  return 0;
}

void main() {
  stdout.writeln(run('lib/i18n/puzzle_17_test.txt'));
  //  stdout.writeln(run('lib/i18n/puzzle_17_input.txt'));
}
