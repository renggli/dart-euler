import 'package:data/data.dart';

import '../../utils.dart';

class AoC2025Day3 extends AoC {
  AoC2025Day3()
    : super(
        year: 2025,
        day: 3,
        part1: 17034,
        part2: 168798209663590,
        examples: [
          AoCExample(
            input: [
              '987654321111111',
              '811111111111119',
              '234234234234278',
              '818181911112111',
            ].join('\n'),
            part1: 357,
            part2: 3121910778619,
          ),
        ],
      );

  List<List<int>> parse(String input) => input
      .split('\n')
      .map((line) => line.split('').map(int.parse).toList())
      .toList();

  int solve(List<int> digits, int count) {
    var position = 0;
    var result = 0;
    for (var remaining = count; remaining >= 1; remaining--) {
      final searchEnd = digits.length - remaining;
      for (var digit = 9; digit >= 1; digit--) {
        final index = digits.indexOf(digit, position);
        if (index != -1 && index <= searchEnd) {
          result = result * 10 + digit;
          position = index + 1;
          break;
        }
      }
    }
    return result;
  }

  @override
  int part1(String input) => parse(input).map((line) => solve(line, 2)).sum();

  @override
  int part2(String input) => parse(input).map((line) => solve(line, 12)).sum();
}

void main() => MainRunner().runProblem(AoC2025Day3());
