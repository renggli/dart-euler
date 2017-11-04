library euler.test.all_test;

import 'package:euler/euler.dart';
import 'package:test/test.dart';

void main() {
  allProblemsDo((problem, executor) {
    test('Problem $problem', () {
      var result = executor();
      if (result.exitCode != 0) {
        fail(result.stderr);
      }
      expect(result.exitCode, 0, reason: 'Exit code');
    });
  }, arguments: ['--checked']);
}
