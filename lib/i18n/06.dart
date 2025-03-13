import 'dart:convert';
import 'dart:io';

Iterable<String> readLines(String filename) sync* {
  var index = 1;
  for (final line in File(filename).readAsLinesSync()) {
    var result = line;
    if (index % 3 == 0) result = utf8.decode(latin1.encode(result));
    if (index % 5 == 0) result = utf8.decode(latin1.encode(result));
    yield result;
    index++;
  }
}

int run(String filename) {
  final input = readLines(filename);
  final dictionary = input.takeWhile((word) => word.isNotEmpty).toList();
  final crosswords = input.skipWhile((word) => word.isNotEmpty).skip(1);

  var result = 0;
  for (final crossword in crosswords) {
    final regexp = RegExp('^${crossword.trim()}\$', unicode: true);
    final index = dictionary.indexWhere(
      (word) => regexp.stringMatch(word) != null,
    );
    if (index == -1) throw StateError(crossword);
    print('$crossword: ${index + 1}');
    result += index + 1;
  }
  return result;
}

void main() {
  assert(run('lib/i18n/06-test.txt') == 50);
  assert(run('lib/i18n/06-input.txt') == 11252);
}
