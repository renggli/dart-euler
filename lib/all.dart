import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:more/collection.dart';

class Group {
  Group(this.directory);

  final Directory directory;

  String get name => directory.path
      .takeLastTo('/')
      .replaceAll('_', ' ')
      .toUpperCaseFirstCharacter();

  Iterable<Group> get groups => directory
      .listSync()
      .whereType<Directory>()
      .map(Group.new)
      .where((group) => group.groups.isNotEmpty || group.problems.isNotEmpty)
      .sortedBy((group) => group.name);

  Iterable<Problem> get problems => directory
      .listSync()
      .whereType<File>()
      .where((file) => file.path.contains(Problem.filePattern))
      .map(Problem.new)
      .sortedBy((problem) => problem.name);
}

class Problem {
  Problem(this.file);

  final File file;

  String get name => file.path
      .takeLastTo('/')
      .removeSuffix('.dart')
      .replaceAll('_', ' ')
      .toUpperCaseFirstCharacter();

  Future<ProcessResult> execute({List<String> arguments = const []}) =>
      Process.run(
        Platform.executable,
        ['run', '--enable-asserts', ...arguments, file.path],
        stdoutEncoding: utf8,
        stderrEncoding: utf8,
      );

  static final filePattern = RegExp(r'(.*_\d+)\.dart');
}

final all = Group(Directory('${Directory.current.path}/lib'));
