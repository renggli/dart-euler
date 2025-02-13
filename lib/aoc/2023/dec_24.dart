import 'dart:ffi';
import 'dart:io';

import 'package:data/data.dart';
import 'package:more/more.dart';
import 'package:z3/z3.dart';

final stones =
    File('lib/aoc/2023/dec_24.txt')
        .readAsLinesSync()
        .map((line) => line.partition(' @ '))
        .map(
          (part) => (
            p: Vector.fromIterable(
              DataType.float,
              part[0].split(', ').map(double.parse),
            ),
            v: Vector.fromIterable(
              DataType.float,
              part[2].split(', ').map(double.parse),
            ),
          ),
        )
        .toList();

double intersection2D(
  Vector<double> a1,
  Vector<double> a2,
  Vector<double> b1,
  Vector<double> b2,
) {
  final t1 =
      (a1[0] - b1[0]) * (b1[1] - b2[1]) - (a1[1] - b1[1]) * (b1[0] - b2[0]);
  final t2 =
      (a1[0] - a2[0]) * (b1[1] - b2[1]) - (a1[1] - a2[1]) * (b1[0] - b2[0]);
  return t1 / t2;
}

int problem1() {
  var count = 0;
  const min = 200000000000000, max = 400000000000000;
  for (final MapEntry(key: ai, value: a) in stones.indexed()) {
    for (final MapEntry(key: bi, value: b) in stones.indexed()) {
      if (ai < bi) {
        final ta = intersection2D(a.p, a.p + a.v, b.p, b.p + b.v);
        final tb = intersection2D(b.p, b.p + b.v, a.p, a.p + a.v);
        if (ta >= 0 && tb >= 0) {
          final i = a.p + a.v * ta;
          if (i[0].between(min, max) && i[1].between(min, max)) {
            count++;
          }
        }
      }
    }
  }
  return count;
}

// Using Z3 constraints solver.
int problem2a() {
  libz3Override = DynamicLibrary.open('/opt/homebrew/lib/libz3.dylib');

  final s = solver();
  final px = constVar('px', realSort), vx = constVar('vx', realSort);
  final py = constVar('py', realSort), vy = constVar('vy', realSort);
  final pz = constVar('pz', realSort), vz = constVar('vz', realSort);

  for (final MapEntry(key: i, value: h) in stones.take(3).indexed()) {
    final t = constVar('t$i', realSort);
    s.add(eq(px + t * vx, $(h.p[0].toInt()) + t * $(h.v[0].toInt())));
    s.add(eq(py + t * vy, $(h.p[1].toInt()) + t * $(h.v[1].toInt())));
    s.add(eq(pz + t * vz, $(h.p[2].toInt()) + t * $(h.v[2].toInt())));
  }

  assert(s.check() == true, s.getReasonUnknown());
  return s.getModel().eval(px)!.toInt() +
      s.getModel().eval(py)!.toInt() +
      s.getModel().eval(pz)!.toInt();
}

// Using linear algebra following this idea:
// https://www.reddit.com/r/adventofcode/comments/18pnycy/comment/kepu26z/
int problem2b() {
  Matrix<double> crossMatrix(Vector<double> vector) =>
      Matrix.fromRows(DataType.float, [
        [0, -vector[2], vector[1]],
        [vector[2], 0, -vector[0]],
        [-vector[1], vector[0], 0],
      ]);

  final a = Matrix(DataType.float, 6, 6);
  (crossMatrix(stones[0].v) - crossMatrix(stones[1].v)).copyInto(
    a.range(0, 3, 0, 3),
  );
  (crossMatrix(stones[0].v) - crossMatrix(stones[2].v)).copyInto(
    a.range(3, 6, 0, 3),
  );
  (crossMatrix(stones[1].p) - crossMatrix(stones[0].p)).copyInto(
    a.range(0, 3, 3, 6),
  );
  (crossMatrix(stones[2].p) - crossMatrix(stones[0].p)).copyInto(
    a.range(3, 6, 3, 6),
  );

  final b = Vector(DataType.float, 6);
  (stones[1].p.cross(stones[1].v) - stones[0].p.cross(stones[0].v)).copyInto(
    b.range(0, 3),
  );
  (stones[2].p.cross(stones[2].v) - stones[0].p.cross(stones[0].v)).copyInto(
    b.range(3, 6),
  );

  final x = a.inverse.mulVector(b);
  return x.range(0, 3).sum.round();
}

// Using linear algebra following this idea:
// https://www.reddit.com/r/adventofcode/comments/18pnycy/comment/kepu26z/
int problem2c() {
  (Vector<double>, double) findPlane(
    Vector<double> p1,
    Vector<double> v1,
    Vector<double> p2,
    Vector<double> v2,
  ) {
    final p12 = p1 - p2, v12 = v1 - v2;
    return (p12.cross(v12), p12.dot(v1.cross(v2)));
  }

  final (a, at) = findPlane(stones[1].p, stones[1].v, stones[2].p, stones[2].v);
  final (b, bt) = findPlane(stones[1].p, stones[1].v, stones[3].p, stones[3].v);
  final (c, ct) = findPlane(stones[2].p, stones[2].v, stones[3].p, stones[3].v);

  final w =
      b.cross(c).mulScalar(at) +
      c.cross(a).mulScalar(bt) +
      a.cross(b).mulScalar(ct);
  final t = a.dot(b.cross(c));
  final v = w.divScalar(t);

  final w1 = stones[1].v - v;
  final w2 = stones[2].v - v;
  final ww = w1.cross(w2);

  final e = ww.dot(stones[2].p.cross(w2));
  final f = ww.dot(stones[1].p.cross(w1));
  final g = stones[1].p.dot(ww);
  final s = ww.dot(ww);
  final r = w1.mulScalar(e) - w2.mulScalar(f) + ww.mulScalar(g);

  return r.divScalar(s).sum.round();
}

void main() {
  assert(problem1() == 17776);
  assert(problem2a() == 948978092202212);
  assert(problem2b() == 948978092202212);
  assert(problem2c() == 948978092202212);
}
