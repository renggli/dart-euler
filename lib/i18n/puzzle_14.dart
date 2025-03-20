import 'dart:io';

import 'package:data/data.dart';
import 'package:petitparser/petitparser.dart';

// Parser for Japanese numbers.

Parser<T> mappedParser<T>(Map<String, T> mapping) =>
    mapping.entries
        .map((entry) => char(entry.key).map((_) => entry.value))
        .toChoiceParser();

Parser<int> japaneseCombiner(Parser<int> a, Parser<int> b) => [
  seq2(a, b).map2((a, b) => a * b),
  a,
  b,
].toChoiceParser().plus().map((list) => list.sum());

final japaneseNumber = japaneseCombiner(
  japaneseCombiner(
    mappedParser({
      '一': 1, // ichi
      '二': 2, // ni
      '三': 3, // san
      '四': 4, // yon
      '五': 5, // go
      '六': 6, // roku
      '七': 7, // nana
      '八': 8, // hachi
      '九': 9, // kyu
    }),
    mappedParser({
      '十': 10, // ju
      '百': 100, // hyaku
      '千': 1000, // sen
    }),
  ),
  mappedParser({
    '万': 10000, // man
    '億': 100000000, // ichioku
  }),
);

// Parser for Japanese units of length.

const shaku = 10 / 33;

final japaneseLength =
    seq2(
      japaneseNumber,
      mappedParser({
        '尺': shaku, // 1 Shaku (尺) = 10/33 m
        '間': 6 * shaku, // 1 Ken (間) = 6 Shaku (尺)
        '丈': 10 * shaku, // 1 Jo (丈) = 10 Shaku (尺)
        '町': 360 * shaku, // 1 Cho (町) = 360 Shaku (尺)
        '里': 12960 * shaku, // 1 Ri (里) = 12960 Shaku (尺)
        '毛': shaku / 10000, // 10,000 Mo (毛) = 1 Shaku (尺)
        '厘': shaku / 1000, // 1000 Rin (厘) = 1 Shaku (尺)
        '分': shaku / 100, // 100 Bu (分) = 1 Shaku (尺)
        '寸': shaku / 10, // 10 Sun (寸) = 1 Shaku (尺)
      }),
    ).map2((a, b) => a * b).end();

// Actual Puzzle.

int run(String filename) =>
    File(filename)
        .readAsLinesSync()
        .map(
          (line) =>
              line
                  .split(' × ')
                  .map((part) => japaneseLength.parse(part).value)
                  .product(),
        )
        .sum()
        .round();

void main() {
  for (final (input, expected) in [
    // Number examples
    ('三百', 300),
    ('三百二十一', 321),
    ('四千', 4000),
    ('五万', 50000),
    ('九万九千九百九十九', 99999),
    ('四十二万四十二', 420042),
    ('九億八千七百六十五万四千三百二十一', 987654321),
    // Units examples
    ('二百四十二', 242),
    ('三百五十一', 351),
    ('七十八', 78),
    ('二十一万七千八百', 217800),
    ('七万二千三百五十八', 72358),
    ('六百十二', 612),
    ('六', 6),
    ('三十万七千九十八', 307098),
    ('九', 9),
    ('三万三千百五十四', 33154),
    ('六百', 600),
    ('七百四十四万千五百', 7441500),
    ('七十八億二千八十三万五千', 7820835000),
    ('二十八万八千六百', 288600),
    ('三百七十四万二千五百三十', 3742530),
    ('六百七十一万七千', 6717000),
  ]) {
    final actual = japaneseNumber.end().parse(input).value;
    assert(actual == expected, '$input expected $expected, but got $actual');
  }
  assert(run('lib/i18n/puzzle_14_test.txt') == 2177741195);
  assert(run('lib/i18n/puzzle_14_input.txt') == 130675442686);
}
