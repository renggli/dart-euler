import 'expectations.dart';
import 'problem.dart';

/// Base class for results of running a problem.
sealed class Result {
  /// The generative constructor for the result.
  Result({
    required this.problem,
    required this.expectation,
    required this.duration,
  });

  /// The problem that was run.
  final Problem problem;

  /// The expectation that was run.
  final Expectation expectation;

  /// The duration of the run.
  final Duration duration;
}

/// A successful run, that was verified to match the expected value.
class Verified extends Result {
  Verified({
    required super.problem,
    required super.expectation,
    required super.duration,
    required this.actual,
  });

  /// The actual value of the run.
  final dynamic actual;
}

/// A successful run, producing an actual value that was not verified.
class Unverified extends Result {
  Unverified({
    required super.problem,
    required super.expectation,
    required super.duration,
    required this.actual,
  });

  /// The actual value of the run.
  final dynamic actual;
}

/// A succesful run, producing a value that does not pass the verification.
class Mismatch extends Result {
  Mismatch({
    required super.problem,
    required super.expectation,
    required super.duration,
    required this.actual,
  });

  /// The actual value of the run.
  final dynamic actual;
}

/// A run that threw an exception.
class Failure extends Result {
  Failure({
    required super.problem,
    required super.expectation,
    required super.duration,
    required this.error,
    required this.stackTrace,
  });

  /// The exception thrown by the run.
  final Object error;

  /// The stack trace of the exception thrown by the run.
  final StackTrace stackTrace;
}
