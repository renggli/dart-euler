import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:more/more.dart';

/// Matches the filename of a problem.
final pattern = RegExp(r'\w+\d+\.dart$');

/// Arguments
final defaults = ['run', '--enable-asserts'];

/// Encapsulate a problem.
class Problem {
  /// Constructs a problem from a path.
  Problem(this.file);

  /// File of the problem.
  final File file;

  /// File path of the problem.
  String get path => file.path;

  /// Label of the problem.
  String get label => path.removePrefix('${Directory.current.path}/lib/');

  /// Tests if this is a valid filename.
  bool get isValid => pattern.hasMatch(label) && file.existsSync();

  /// Executes the problem synchronously.
  ProcessResult executeSync({List<String> arguments = const []}) =>
      Process.runSync(Platform.executable, [...defaults, ...arguments, path]);

  /// Executes the problem asynchronously.
  Future<ProcessResult> execute({List<String> arguments = const []}) =>
      Process.run(Platform.executable, [...defaults, ...arguments, path],
          stdoutEncoding: utf8, stderrEncoding: utf8);
}

/// Iterator over all the Euler problems.
Iterable<Problem> get problems => Directory.current
    .listSync(recursive: true, followLinks: false)
    .whereType<File>()
    .map((file) => Problem(file))
    .where((problem) => problem.isValid);

void main() {
  for (final problem in problems) {
    stdout.write(problem.label);
    final result = problem.executeSync();
    stdout.writeln(result.exitCode == 0 ? '' : ' [FAILURE]');
  }
}
