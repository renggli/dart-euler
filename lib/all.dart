import 'dart:async';
import 'dart:io';

/// Matches the filename of a problem.
final RegExp pattern = RegExp(r'problem_(\d+)\.dart$');

/// Encapsulate a problem.
class Problem {
  /// Constructs a problem from a path.
  Problem(this.file);

  /// File of the problem.
  final File file;

  /// File path of the problem.
  String get path => file.path;

  /// Label of the problem.
  String get label => path.startsWith(Directory.current.path)
      ? path.substring(Directory.current.path.length + 1)
      : path;

  /// Executes the problem synchronously.
  ProcessResult executeSync({List<String> arguments = const []}) =>
      Process.runSync(Platform.executable, [...arguments, path]);

  /// Executes the problem asynchronously.
  Future<ProcessResult> execute({List<String> arguments = const []}) =>
      Process.run(Platform.executable, [...arguments, path]);
}

/// Iterator over all the Euler problems.
Iterable<Problem> get problems => Directory.current.parent
    .listSync(recursive: true, followLinks: false)
    .where((file) => pattern.hasMatch(file.path))
    .map((file) => Problem(file));

void main() {
  for (final problem in problems) {
    stdout.write(problem.label);
    final result = problem.executeSync();
    stdout.writeln(result.exitCode == 0 ? '' : ' [FAILURE]');
  }
}
