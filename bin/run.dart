import 'dart:io';

import 'package:euler/all.dart';

const indent = '  ';

Future<void> runGroup(Group parent, {int level = 0}) async {
  stdout.writeln('${indent * level}${parent.name}');
  for (final group in parent.groups) {
    await runGroup(group, level: level + 1);
  }
  for (final problem in parent.problems) {
    stdout.write('${indent * (level + 1)}${problem.name}: ');
    final stopwatch = Stopwatch()..start();
    final result = await problem.execute();
    stopwatch.stop();
    stdout.write(result.exitCode == 0 ? 'SUCCESS' : 'FAILURE');
    final timeMs = stopwatch.elapsedMilliseconds;
    stdout.writeln(' [${timeMs.toString().padLeft(4)}ms]');
  }
}

void main() async {
  for (final group in all.groups) {
    await runGroup(group);
  }
}
