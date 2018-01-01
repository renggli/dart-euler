library euler;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Matches the filename of a problem.
final pattern = new RegExp(r'problem_(\d+)\.dart$');

/// Encapsulate an euler problem.
class Problem {

  /// Constructs a problem from a path.
  Problem(this.path);

  /// Filename of the problem.
  final String path;

  /// Number of the problem.
  int get number => int.parse(pattern.firstMatch(path).group(1));

  /// Executes the problem synchronously.
  ProcessResult executeSync({List<String> arguments: const []}) {
    return Process.runSync(
        Platform.executable,
        []
          ..addAll(arguments)
          ..add(path),
        stdoutEncoding: UTF8,
        stderrEncoding: UTF8);
  }

  /// Executes the problem asynchronously.
  Future<ProcessResult> execute({List<String> arguments: const []}) {
    return Process.run(
        Platform.executable,
        []
          ..addAll(arguments)
          ..add(path),
        stdoutEncoding: UTF8,
        stderrEncoding: UTF8);
  }
}

/// Iterator over all the Euler problems.
Iterable<Problem> get problems {
  return Directory.current.parent
      .listSync(recursive: true, followLinks: false)
      .where((file) => pattern.hasMatch(file.path))
      .map((file) => new Problem(file.path));
}

void main() {
  for (var problem in problems) {
    stdout.write('Problem ${problem.number}');
    var result = problem.executeSync();
    stdout.writeln(result.exitCode == 0 ? '' : ' [FAILURE]');
  }
}
