import 'dart:io';

import 'package:collection/collection.dart' show ListExtensions;
import 'package:data/data.dart';
import 'package:more/more.dart';

final input = File('lib/aoc/2024/dec_09.txt').readAsStringSync().trim();
final blocks = input.split('').indexed().flatMap((each) => repeat(
    each.index.isEven ? each.index ~/ 2 : null,
    count: int.parse(each.value)));

int computeChecksum(List<int?> blocks) =>
    blocks.indexed().map((each) => each.index * (each.value ?? 0)).sum();

int problem1(List<int?> blocks) {
  for (var i = 0, j = blocks.length - 1; i < j;) {
    while (blocks[i] != null) {
      i++;
    }
    while (blocks[j] == null) {
      j--;
    }
    if (i < j) blocks.swap(i, j);
  }
  return computeChecksum(blocks);
}

int? firstEmptyRange(List<int?> blocks, int minSize) {
  var start = 0;
  while (start < blocks.length) {
    while (blocks[start] != null) {
      start++;
    }
    var end = start;
    while (end < blocks.length && blocks[end] == null) {
      end++;
    }
    if (minSize <= end - start) return start;
    start = end + 1;
  }
  return null;
}

int problem2(List<int?> blocks) {
  var end = blocks.length - 1;
  while (true) {
    while (end > 0 && blocks[end] == null) {
      end--;
    }
    var start = end;
    while (start > 0 && blocks[start] == blocks[end]) {
      start--;
    }
    if (start == end) break;
    final empty = firstEmptyRange(blocks, end - start);
    if (empty != null && empty <= start) {
      for (var i = start + 1, j = empty; i <= end; i++, j++) {
        blocks.swap(i, j);
      }
    }
    end = start;
  }
  return computeChecksum(blocks);
}

void main() {
  assert(problem1([...blocks]) == 6359213660505);
  assert(problem2([...blocks]) == 6381624803796);
}
