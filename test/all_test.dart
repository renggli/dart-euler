// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library all_test;

import 'dart:io';
import 'dart:convert';
import 'dart:platform' as Platform;

import 'package:unittest/unittest.dart';

void main(List<String> arguments) {
  var directory = arguments.isEmpty
      ? Directory.current.parent
      : new Directory(arguments.first);
  var pattern = new RegExp(r'problem_\d\d\d\.dart$');
  directory
    .listSync(recursive: true, followLinks: false)
    .where((file) => pattern.hasMatch(file.path))
    .forEach((file) {
      test(file.path, () {
        var result = Process.runSync(
            Platform.executable,
            ['--checked', file.path],
            stdoutEncoding: UTF8,
            stderrEncoding: UTF8);
        expect(result.exitCode, 0, reason: 'Exit code');
      });
    });
}