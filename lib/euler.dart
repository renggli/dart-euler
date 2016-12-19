library euler;

import 'dart:io';
import 'dart:convert';

typedef ProcessResult Executor();

typedef void ProblemHandler(int problem, Executor executor);

void allProblemsDo(ProblemHandler handler, {List<String> arguments: const []}) {
  var pattern = new RegExp(r'problem_(\d\d\d)\.dart$');
  return Directory.current.parent
      .listSync(recursive: true, followLinks: false)
      .where((file) => pattern.hasMatch(file.path))
      .forEach((file) {
        var problem = int.parse(pattern.firstMatch(file.path).group(1));
        var executor = () {
          return Process.runSync(
                Platform.executable,
                new List()
                    ..addAll(arguments)
                    ..add(file.path),
                stdoutEncoding: UTF8,
                stderrEncoding: UTF8);
        };
        handler(problem, executor);
      });
}

void main() {
  allProblemsDo((int problem, Executor executor) {
    stdout.write('Problem $problem');
    var result = executor();
    stdout.writeln(result.exitCode == 0 ? '' : ' [FAILURE]');
  }, arguments: ['--checked']);
}
