import 'dart:io';

int run(String filename) {
  final input = File(filename).readAsStringSync();
  // TODO: solve the puzzle
  return input.length;
}

void main() {
  stdout.writeln(run('lib/i18n/puzzle_19_test.txt'));
  stdout.writeln(run('lib/i18n/puzzle_19_input.txt'));
}
