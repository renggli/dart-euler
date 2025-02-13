import 'dart:io';

import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef Range = ({int start, int end});
typedef Mapping = ({int target, int source, int length});

final data =
    File('lib/aoc/2023/dec_05.txt')
        .readAsStringSync()
        .split('\n\n')
        .map(
          (block) =>
              block
                  .skipTo(RegExp(r':\s+'))
                  .split(RegExp(r'\s+'))
                  .map(int.parse)
                  .toList(),
        )
        .toList();
final initialSeeds = data[0];
final mappings =
    data
        .skip(1)
        .map(
          (block) =>
              block
                  .chunked(3)
                  .map(
                    (each) => (
                      target: each[0],
                      source: each[1],
                      length: each[2],
                    ),
                  )
                  .toList(),
        )
        .toList();

List<Range> transform(List<Range> ranges, List<Mapping> mappings) {
  final result = <Range>[];
  final queue = QueueList.from(ranges);
  while (queue.isNotEmpty) {
    var found = false;
    final range = queue.removeFirst();
    final (:start, :end) = range;
    for (final (:target, :source, :length) in mappings) {
      if (start >= source && end < source + length) {
        // Range is inside the mapping
        result.add((
          start: start - source + target,
          end: end - source + target,
        ));
        found = true;
      } else if (start < source && end >= source && end < source + length) {
        // Range overlaps the lower end of the mapping
        queue.add((start: start, end: source - 1));
        result.add((start: target, end: target + end - source));
        found = true;
      } else if (start < source + length &&
          end >= source + length &&
          start >= source) {
        // Range overlaps the upper end of the mapping
        queue.add((start: source + length, end: end));
        result.add((start: target + start - source, end: target + length - 1));
        found = true;
      } else if (start < source && end >= source + length) {
        // Range overlaps the complete mapping
        queue.add((start: start, end: source - 1));
        result.add((start: target, end: target + length - 1));
        queue.add((start: source + length, end: end));
        found = true;
      }
      if (found) break;
    }
    if (!found) result.add(range);
  }
  return result;
}

int compute(List<Range> seeds) {
  for (final mapping in mappings) {
    seeds = transform(seeds, mapping);
  }
  return seeds.map((range) => range.start).min;
}

int problem1() =>
    compute(initialSeeds.map((each) => (start: each, end: each)).toList());

int problem2() => compute(
  initialSeeds
      .chunked(2)
      .map((each) => (start: each.first, end: each.first + each.last - 1))
      .toList(),
);

void main() {
  assert(problem1() == 910845529);
  assert(problem2() == 77435348);
}
