import 'package:checks/checks.dart';
import 'package:euler/all.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void createGroup(Group groupDef) {
  group(groupDef.name, () {
    groupDef.groups.forEach(createGroup);
    for (final problem in groupDef.problems) {
      test(problem.name, () async {
        final result = await problem.execute();
        check(result)
          ..succeeded()
          ..stderr.equals('');
      });
    }
  });
}

void main() {
  all.groups.forEach(createGroup);
}
