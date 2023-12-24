import 'dart:ffi';
import 'dart:io';

import 'package:more/more.dart';
import 'package:z3/z3.dart';

class Point3 {
  Point3(this.x, this.y, this.z);

  Point3.fromList(Iterable<num> values)
      : x = values.elementAt(0),
        y = values.elementAt(1),
        z = values.elementAt(2);

  final num x, y, z;

  Point3 operator +(Point3 other) =>
      Point3(x + other.x, y + other.y, z + other.z);

  Point3 operator *(num factor) => Point3(x * factor, y * factor, z * factor);

  @override
  String toString() => 'Point3($x, $y, $z)';
}

// final hailstones = File('lib/aoc/2023/dec_00.txt')
final hailstones = File('lib/aoc/2023/dec_24.txt')
    .readAsLinesSync()
    .map((line) => line.partition(' @ '))
    .map((line) => (
          p: Point3.fromList(line[0].split(', ').map(int.parse)),
          v: Point3.fromList(line[2].split(', ').map(int.parse)),
        ))
    .toList();

double intersection2D(Point3 a1, Point3 a2, Point3 b1, Point3 b2) {
  final t1 = (a1.x - b1.x) * (b1.y - b2.y) - (a1.y - b1.y) * (b1.x - b2.x);
  final t2 = (a1.x - a2.x) * (b1.y - b2.y) - (a1.y - a2.y) * (b1.x - b2.x);
  return t1 / t2;
}

int problem1() {
  var count = 0;
  const min = 200000000000000, max = 400000000000000;
  for (final MapEntry(key: ai, value: a) in hailstones.indexed()) {
    for (final MapEntry(key: bi, value: b) in hailstones.indexed()) {
      if (ai < bi) {
        final ta = intersection2D(a.p, a.p + a.v, b.p, b.p + b.v);
        final tb = intersection2D(b.p, b.p + b.v, a.p, a.p + a.v);
        if (ta >= 0 && tb >= 0) {
          final i = a.p + a.v * ta;
          if (i.x.between(min, max) && i.y.between(min, max)) {
            count++;
          }
        }
      }
    }
  }
  return count;
}

int problem2() {
  libz3Override = DynamicLibrary.open('/opt/homebrew/lib/libz3.dylib');
  final s = solver();
  final px = constVar('px', realSort), vx = constVar('vx', realSort);
  final py = constVar('py', realSort), vy = constVar('vy', realSort);
  final pz = constVar('pz', realSort), vz = constVar('vz', realSort);
  for (final MapEntry(key: i, value: h) in hailstones.take(3).indexed()) {
    final t = constVar('t$i', realSort);
    s.add(eq(px + t * vx, $(h.p.x) + t * $(h.v.x)));
    s.add(eq(py + t * vy, $(h.p.y) + t * $(h.v.y)));
    s.add(eq(pz + t * vz, $(h.p.z) + t * $(h.v.z)));
  }
  assert(s.check() == true, s.getReasonUnknown());
  return s.getModel().eval(px)!.toInt() +
      s.getModel().eval(py)!.toInt() +
      s.getModel().eval(pz)!.toInt();
}

void main() {
  assert(problem1() == 17776);
  assert(problem2() == 948978092202212);
}
