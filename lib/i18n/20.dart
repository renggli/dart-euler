import 'dart:io';

int run(String filename) {
  final input = File(filename).readAsStringSync();
  // TODO: solve the puzzle
  return input.length;
}

void main() {
  print(run('lib/i18n/20-test.txt'));
  print(run('lib/i18n/20-input.txt'));
}
