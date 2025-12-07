import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

final input = File('lib/aoc/2015/dec_04.txt').readAsLinesSync();

int find(String secretKey, String prefix) {
  var i = 1;
  while (true) {
    final combined = secretKey + i.toString();
    final hash = md5.convert(utf8.encode(combined));
    final hexHash = hash.toString();
    if (hexHash.startsWith(prefix)) {
      return i;
    }
    i++;
  }
}

int part1() => find(input.first, '00000');

int part2() => find(input.first, '000000');

void main() {
  assert(part1() == 117946);
  assert(part2() == 3938038);
}
