import 'aoc/2025/dec_01.dart';
import 'aoc/2025/dec_02.dart';
import 'aoc/2025/dec_03.dart';
import 'aoc/2025/dec_04.dart';
import 'aoc/2025/dec_05.dart';
import 'aoc/2025/dec_06.dart';
import 'aoc/2025/dec_07.dart';
import 'aoc/2025/dec_08.dart';
import 'aoc/2025/dec_09.dart';
import 'aoc/2025/dec_10.dart';
import 'aoc/2025/dec_11.dart';
import 'aoc/2025/dec_12.dart';
import 'utils.dart';

final all = Group(
  label: 'Lib',
  subgroups: [
    Group(
      label: 'Aoc',
      subgroups: [
        Group(label: '2015', problems: []),
        Group(label: '2019', problems: []),
        Group(label: '2020', problems: []),
        Group(label: '2022', problems: []),
        Group(label: '2023', problems: []),
        Group(label: '2024', problems: []),
        Group(
          label: '2025',
          problems: [
            AoC2025Day1(),
            AoC2025Day2(),
            AoC2025Day3(),
            AoC2025Day4(),
            AoC2025Day5(),
            AoC2025Day6(),
            AoC2025Day7(),
            AoC2025Day8(),
            AoC2025Day9(),
            AoC2025Day10(),
            AoC2025Day11(),
            AoC2025Day12(),
          ],
        ),
      ],
    ),
    Group(
      label: 'Euler',
      subgroups: [
        Group(label: '001-010', problems: []),
        Group(label: '011-020', problems: []),
        Group(label: '021-030', problems: []),
        Group(label: '031-040', problems: []),
        Group(label: '041-050', problems: []),
        Group(label: '051-060', problems: []),
        Group(label: '061-070', problems: []),
        Group(label: '071-080', problems: []),
      ],
    ),
    Group(label: 'I18n', problems: []),
  ],
);
