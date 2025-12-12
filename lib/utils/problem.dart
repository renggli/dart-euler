import 'dart:async';

import 'runner.dart';

/// A problem to solve.
abstract class Problem {
  Problem({required this.label});

  final String label;

  FutureOr<void> run(Runner runner);
}
