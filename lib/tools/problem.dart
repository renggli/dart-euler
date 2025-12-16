import 'dart:async';

import 'expectations.dart';
import 'results.dart';

/// Annotates a runnable problem.
abstract class Problem {
  const Problem();

  /// Human readable label of the problem.
  String get label;

  /// Expectations to run against the problem.
  Stream<Expectation> get expectations;

  /// The generator function to run the problem.
  Stream<Result> run(FutureOr<dynamic> Function(dynamic) callback) =>
      expectations.asyncMap((expectation) async {
        final input = await expectation.input;
        final stopwatch = Stopwatch()..start();
        try {
          final actual = await callback(input);
          if (expectation.expected != null) {
            if (expectation.expected == actual) {
              return Verified(
                problem: this,
                expectation: expectation,
                duration: stopwatch.elapsed,
                actual: actual,
              );
            } else {
              return Mismatch(
                problem: this,
                expectation: expectation,
                duration: stopwatch.elapsed,
                actual: actual,
              );
            }
          } else {
            return Unverified(
              problem: this,
              expectation: expectation,
              duration: stopwatch.elapsed,
              actual: actual,
            );
          }
        } catch (error, stackTrace) {
          return Failure(
            problem: this,
            expectation: expectation,
            duration: stopwatch.elapsed,
            error: error,
            stackTrace: stackTrace,
          );
        }
      });
}
