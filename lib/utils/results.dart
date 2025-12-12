import 'dart:async';

import 'package:meta/meta.dart';

/// Base class for results of running a problem.
@optionalTypeArgs
sealed class Result<R> {
  /// Produces a result of running a problem.
  static Future<Result<R>> run<R>(
    String label,
    FutureOr<R> Function() callback, {
    R? expected,
  }) async {
    final stopwatch = Stopwatch();
    try {
      stopwatch.start();
      final actual = await callback();
      stopwatch.stop();
      if (expected != null) {
        if (actual == expected) {
          return Verified(
            label: label,
            duration: stopwatch.elapsed,
            actual: actual,
          );
        } else {
          return Mismatch(
            label: label,
            duration: stopwatch.elapsed,
            actual: actual,
            expected: expected,
          );
        }
      } else {
        return Unverified(
          label: label,
          duration: stopwatch.elapsed,
          actual: actual,
        );
      }
    } catch (error, stackTrace) {
      stopwatch.stop();
      return Failure(
        label: label,
        duration: stopwatch.elapsed,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// The generative constructor for the result.
  Result({required this.label, required this.duration});

  /// The label of the run.
  final String label;

  /// The duration of the run.
  final Duration duration;
}

/// A successful run, that was verified to match the expected value.
class Verified<R> extends Result<R> {
  Verified({
    required super.label,
    required super.duration,
    required this.actual,
  });

  /// The actual value of the run.
  final R actual;
}

/// A successful run, producing an actual value that was not verified.
class Unverified<R> extends Result<R> {
  Unverified({
    required super.label,
    required super.duration,
    required this.actual,
  });

  /// The actual value of the run.
  final R actual;
}

/// A succesful run, producing a value that does not pass the verification.
class Mismatch<R> extends Result<R> {
  Mismatch({
    required super.label,
    required super.duration,
    required this.actual,
    required this.expected,
  });

  /// The actual value of the run.
  final R actual;

  /// The expected value of the run.
  final R expected;
}

/// A run that threw an exception.
class Failure<R> extends Result<R> {
  Failure({
    required super.label,
    required super.duration,
    required this.error,
    required this.stackTrace,
  });

  /// The exception thrown by the run.
  final Object error;

  /// The stack trace of the exception thrown by the run.
  final StackTrace stackTrace;
}
