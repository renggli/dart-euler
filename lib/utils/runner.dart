import 'dart:async';

import 'group.dart';
import 'problem.dart';
import 'results.dart';

/// A runner for executing problems.
abstract interface class Runner {
  /// Runs a group of problems.
  FutureOr<void> runGroup(Group group);

  /// Runs a problem.
  FutureOr<void> runProblem(Problem problem);

  /// Adds a result of running a problem.
  void addResult(Result result);
}
