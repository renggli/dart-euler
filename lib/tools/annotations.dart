import 'package:meta/meta.dart';

/// Abstract superclass of the problem annotations.
@optionalTypeArgs
sealed class Problem<R> {
  const Problem({required this.label, this.expected});

  /// Human readable problem label.
  final String label;

  /// The expected result of the problem.
  final R? expected;
}

/// Annotates an Advent of Code problem.
class AoC extends Problem<int> {
  const AoC({
    required this.year,
    required this.day,
    required this.part,
    super.expected,
  }) : super(label: 'AoC $year Day $day Part $part');

  /// The year of the problem.
  final int year;

  /// The day of the problem.
  final int day;

  /// The part of the problem.
  final int part;
}

/// Annotates a Project Euler problem.
class Euler extends Problem<int> {
  const Euler({required this.problem, super.expected})
    : super(label: 'Euler $problem');

  /// The number of the problem.
  final int problem;
}

/// Annotates a i18n problem.
class I18N extends Problem<String> {
  const I18N({required this.problem, required this.part, super.expected})
    : super(label: 'I18n $problem Part $part');

  /// The problem number.
  final int problem;

  /// The part of the problem.
  final int part;
}
