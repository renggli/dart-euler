library euler;

import 'dart:async';
import 'dart:io';

/// Matches the filename of a problem.
final pattern = RegExp(r'problem_(\d+)\.dart$');

/// Encapsulate an euler problem.
class Problem {
  /// Constructs a problem from a path.
  Problem(this.path);

  /// Filename of the problem.
  final String path;

  /// Number of the problem.
  int get number => int.parse(pattern.firstMatch(path).group(1));

  /// Executes the problem synchronously.
  ProcessResult executeSync({List<String> arguments = const []}) =>
      Process.runSync(
          Platform.executable,
          []
            ..addAll(arguments)
            ..add(path));

  /// Executes the problem asynchronously.
  Future<ProcessResult> execute({List<String> arguments = const []}) =>
      Process.run(
          Platform.executable,
          []
            ..addAll(arguments)
            ..add(path));
}

/// Iterator over all the Euler problems.
Iterable<Problem> get problems => Directory.current.parent
    .listSync(recursive: true, followLinks: false)
    .where((file) => pattern.hasMatch(file.path))
    .map((file) => Problem(file.path));

void main() {
  for (var problem in problems) {
    stdout.write('Problem ${problem.number}');
    final result = problem.executeSync();
    stdout.writeln(result.exitCode == 0 ? '' : ' [FAILURE]');
  }
}
