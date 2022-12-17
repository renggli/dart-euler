import 'dart:io';

import 'package:data/stats.dart';
import 'package:more/iterable.dart';

abstract class Entry {
  DirEntry? get parent;

  String get name;

  int get size;

  Iterable<Entry> get children => [];

  Iterable<Entry> get all => [this, ...children.expand((each) => each.all)];
}

class FileEntry extends Entry {
  FileEntry(this.parent, this.name, this.size);

  @override
  final DirEntry? parent;

  @override
  final String name;

  @override
  final int size;
}

class DirEntry extends Entry {
  DirEntry(this.parent, this.name);

  @override
  final DirEntry? parent;

  @override
  final String name;

  @override
  int get size => children.map((each) => each.size).sum();

  @override
  final List<Entry> children = [];
}

final root = () {
  final root = DirEntry(null, '/');
  var current = root;
  for (var line in File('lib/aoc/2022/dec_07.txt').readAsLinesSync()) {
    final token = line.split(' ');
    if (token[0] == '\$') {
      if (token[1] == 'cd') {
        if (token[2] == '/') {
          current = root;
        } else if (token[2] == '..') {
          current = current.parent!;
        } else {
          current = current.children.firstWhere((each) => each.name == token[2])
              as DirEntry;
        }
      } else if (token[1] == 'ls') {
        // nothing to do
      } else {
        throw ArgumentError('Invalid command: $line');
      }
    } else {
      if (token[0] == 'dir') {
        current.children.add(DirEntry(current, token[1]));
      } else {
        current.children.add(FileEntry(current, token[1], int.parse(token[0])));
      }
    }
  }
  return root;
}();

void main() {
  assert(root.all
          .whereType<DirEntry>()
          .where((dir) => dir.size <= 100000)
          .map((dir) => dir.size)
          .sum() ==
      919137);

  final required = root.size - 70000000 + 30000000;
  assert(root.all
          .whereType<DirEntry>()
          .map((dir) => dir.size)
          .where((size) => size >= required)
          .min() ==
      2877389);
}
