import 'dart:async';
import 'dart:io';
import 'dart:mirrors';

import 'package:collection/collection.dart';
import 'package:more/more.dart';

import 'expectations.dart';
import 'problem.dart';
import 'results.dart';

Future<void> run() async {
  await for (final result in _runProblems()) {
    final label = '${result.problem.label}, ${result.expectation.label}';
    stdout.write('$asciiBold$label$asciiReset: ');
    switch (result) {
      case Verified():
        stdout.write('${asciiGreen}OK$asciiReset');
      case Unverified():
        stdout.write('$asciiBlue??$asciiReset got ${result.actual}');
      case Mismatch():
        stdout.write(
          '$asciiYellow!!$asciiReset got ${result.actual}, '
          'but expected ${result.expectation.expected}',
        );
      case Failure():
        stdout.write('${asciiRed}XX$asciiReset ${result.error}');
    }
    stdout.writeln(' [${durationFormat(result.duration)}]');
    if (result is Failure) {
      stderr.write(result.stackTrace);
    }
  }
}

Stream<Result> _runProblems() async* {
  final mirrorSystem = currentMirrorSystem();
  for (final libraryMirror in mirrorSystem.libraries.values) {
    for (final methodMirror
        in libraryMirror.declarations.values.whereType<MethodMirror>().sortedBy(
          (methodMirror) => methodMirror.location?.line ?? 0,
        )) {
      for (final instanceMirror in methodMirror.metadata.sortedBy(
        (instanceMirror) => methodMirror.location?.line ?? 0,
      )) {
        if (instanceMirror case InstanceMirror(
          reflectee: final Problem problem,
        )) {
          yield* _runProblem(libraryMirror, methodMirror, problem);
        }
      }
    }
  }
}

Stream<Result> _runProblem(
  LibraryMirror libraryMirror,
  MethodMirror declarationMirror,
  Problem problem,
) async* {
  final method = libraryMirror.declarations[declarationMirror.simpleName];
  await for (final expectation in problem.expectations) {
    yield await _createResult(
      problem: problem,
      expectation: expectation,
      callback: (input) =>
          libraryMirror.invoke(declarationMirror.simpleName, [input]).reflectee,
    );
  }
}

const asciiBold = '\x1b[1m';
const asciiReset = '\x1b[0m';
const asciiRed = '\x1b[31m';
const asciiGreen = '\x1b[32m';
const asciiYellow = '\x1b[33m';
const asciiBlue = '\x1b[34m';

final durationFormat = DurationPrinter(
  (builder) => builder
    ..part(
      TimeUnit.millisecond,
      printer: FixedNumberPrinter<int>(separator: ','),
    )
    ..literal('.')
    ..part(TimeUnit.microsecond, printer: FixedNumberPrinter<int>(padding: 3))
    ..literal('ms'),
);

/// Creates a result based on the execution of callback.
Future<Result> _createResult({
  required Problem problem,
  required Expectation expectation,
  required FutureOr<dynamic> Function(dynamic) callback,
}) async {
  final input = await expectation.input;
  final stopwatch = Stopwatch()..start();
  try {
    final actual = await callback(input);
    if (expectation.expected != null) {
      if (expectation.expected == actual) {
        return Verified(
          problem: problem,
          expectation: expectation,
          duration: stopwatch.elapsed,
          actual: actual,
        );
      } else {
        return Mismatch(
          problem: problem,
          expectation: expectation,
          duration: stopwatch.elapsed,
          actual: actual,
        );
      }
    } else {
      return Unverified(
        problem: problem,
        expectation: expectation,
        duration: stopwatch.elapsed,
        actual: actual,
      );
    }
  } catch (error, stackTrace) {
    return Failure(
      problem: problem,
      expectation: expectation,
      duration: stopwatch.elapsed,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
