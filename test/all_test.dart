library all_test;

import 'package:euler/euler.dart';
import 'package:unittest/unittest.dart';

void main() {
  allProblemsDo((problem, executor) {
    test('Problem $problem', () {
      expect(executor().exitCode, 0, reason: 'Exit code');
    });
  }, arguments: ['--checked']);
}
