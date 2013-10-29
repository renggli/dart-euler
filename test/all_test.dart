// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library all_test;

import 'dart:io';
import 'dart:convert';
import 'dart:platform' as Platform;

import 'package:unittest/unittest.dart';

void main() {
  var pattern = new RegExp(r'problem_(\d\d\d)\.dart$');
  Directory.current.parent
    .listSync(recursive: true, followLinks: false)
    .where((file) => pattern.hasMatch(file.path))
    .forEach((file) {
      test('Problem ${pattern.firstMatch(file.path).group(1)}', () {
        var result = Process.runSync(
            Platform.executable,
            ['--checked', file.path],
            stdoutEncoding: UTF8,
            stderrEncoding: UTF8);
        expect(result.exitCode, 0, reason: 'Exit code');
      });
    });
}