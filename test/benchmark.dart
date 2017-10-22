library euler.test.benchmark;

import 'package:euler/euler.dart';

void main() {
  print('<?xml version="1.0"?>');
  print('<benchmarks>');
  allProblemsDo((problem, executor) {
    var watch = new Stopwatch();
    watch.start();
    var result = executor();
    var elapsed = watch.elapsedMilliseconds;
    if (result.exitCode == 0) {
      print('  <benchmark name="$problem">$elapsed</benchmark>');
    }
  });
  print('</benchmarks>');
}
