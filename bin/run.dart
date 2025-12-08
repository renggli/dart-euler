// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:euler/all.dart';
import 'utils/ansi.dart';

Future<void> runGroup(Group parent, {Pattern? pattern, int level = 0}) async {
  stdout.writeln('$bold${indent * level}${parent.name}$reset');
  for (final group in parent.groups) {
    await runGroup(group, pattern: pattern, level: level + 1);
  }
  for (final problem in parent.problems) {
    if (pattern == null || problem.file.path.contains(pattern)) {
      stdout.write('${indent * (level + 1)}${problem.name}: ');
      final stopwatch = Stopwatch()..start();
      final result = await problem.execute();
      stopwatch.stop();
      stdout.write(
        result.exitCode == 0 ? '${green}SUCCESS$reset' : '${red}FAILURE$reset',
      );
      final timeMs = stopwatch.elapsedMilliseconds.toString().padLeft(4);
      stdout.writeln(' [${yellow}${timeMs}ms$reset]');
    }
  }
}

void main(List<String> args) async {
  final pattern = args.isNotEmpty ? RegExp(args.first) : null;
  for (final group in all.groups) {
    await runGroup(group, pattern: pattern);
  }
}
