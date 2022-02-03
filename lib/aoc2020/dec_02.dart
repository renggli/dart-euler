import 'dart:io';

class Value {
  Value(this.first, this.second, this.letter, this.password);

  factory Value.fromString(String input) {
    final match = pattern.matchAsPrefix(input)!;
    return Value(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      match.group(3)!,
      match.group(4)!,
    );
  }

  final int first;
  final int second;
  final String letter;
  final String password;

  static final pattern = RegExp(r'(\d+)-(\d+) (\w): (\w+)');

  int get letterCount =>
      password.split('').where((each) => each == letter).length;
}

bool isValid1(Value value) =>
    value.first <= value.letterCount && value.letterCount <= value.second;

bool isValid2(Value value) =>
    (1 <= value.first &&
        value.first <= value.password.length &&
        value.password[value.first - 1] == value.letter) !=
    (1 <= value.second &&
        value.second <= value.password.length &&
        value.password[value.second - 1] == value.letter);

final values = File('lib/aoc2020/dec_02.txt')
    .readAsLinesSync()
    .map((line) => Value.fromString(line));

void main() {
  assert(values.where(isValid1).length == 458);
  assert(values.where(isValid2).length == 342);
}
