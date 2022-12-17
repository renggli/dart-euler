import 'package:euler/all.dart';
import 'package:test/test.dart' as test;

void createGroup(Group group) {
  test.group(group.name, () {
    group.groups.forEach(createGroup);
    for (final problem in group.problems) {
      test.test(problem.name, () async {
        final result = await problem.execute();
        if (result.exitCode != 0) {
          test.fail(result.stderr as String);
        }
      });
    }
  });
}

void main() {
  all.groups.forEach(createGroup);
}
