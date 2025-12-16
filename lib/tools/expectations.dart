import 'dart:async';

/// Abstract source of expecations for a problem.
abstract class Expectation {
  const Expectation({required this.label, this.expected});

  /// Label describing the source.
  final String label;

  /// The input of the expectation.
  FutureOr<dynamic> get input;

  /// The expected result.
  final dynamic expected;
}

/// Most basic source of expectations.
class Example extends Expectation {
  const Example(this.input, {String? label, super.expected})
    : super(label: label ?? 'Example');

  @override
  final dynamic input;
}
