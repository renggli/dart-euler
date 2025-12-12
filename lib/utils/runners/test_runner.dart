import 'package:test/test.dart' as test;

import '../group.dart';
import '../problem.dart';
import '../results.dart';
import '../runner.dart';

/// A runner that runs problems using the test package.
class TestRunner implements Runner {
  TestRunner();

  @override
  void runGroup(Group group) {
    test.group(group.label, () {
      for (final group in group.subgroups) {
        runGroup(group);
      }
      for (final problem in group.problems) {
        runProblem(problem);
      }
    });
  }

  @override
  void runProblem(Problem problem) {
    test.test(problem.label, () => problem.run(this));
  }

  @override
  void addResult(Result result) {
    switch (result) {
      case Verified():
        break;
      case Unverified():
        test.fail('Could not verify ${result.actual}.');
      case Mismatch():
        test.fail('Expected ${result.expected}, but got ${result.actual}.');
      case Failure():
        throw result.error;
    }
  }
}
