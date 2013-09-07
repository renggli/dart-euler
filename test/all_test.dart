// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library all_test;

import 'dart:io';
import 'dart:convert';

import 'package:unittest/unittest.dart';

void main() {
  new Directory('../example')
    .list(recursive: true, followLinks: false)
    .where((file) => file.path.endsWith('.dart'))
    .listen((file) {
      test(file.path, () {
        var result = Process.runSync(
            Platform.executable,
            ['--checked', file.path],
            stdoutEncoding: UTF8,
            stderrEncoding: UTF8);
        stdout.write(result.stdout);
        stderr.write(result.stderr);
        expect(result.exitCode, 0, reason: 'Exit code');
      });
    });
}
